# git log --format='%aN' --since=1/1/2023 | Sort-Object -Unique | ForEach-Object {
#     $name = $_
#     $addedLines = 0
#     $removedLines = 0
#     (git log --author="$name" --pretty=tformat: --numstat) | ForEach-Object {
#         if ($_ -match '(\d+)\s+(\d+)') {
#             $addedLines += [int]$matches[1]
#             $removedLines += [int]$matches[2]
#         }
#     }
#     [PSCustomObject]@{
#         Author = $name
#         AddedLines = $addedLines
#         RemovedLines = $removedLines
#         TotalLines = $addedLines - $removedLines
#     }
# } | Format-Table -AutoSize

# Initialize the summary hashtable
$summary = @{}

git log --since="30 days ago" --pretty="%ad" --date=format:'%Y-%m-%d' --stat main | 
    ForEach-Object {
        if ($_ -match "^\d{4}-\d{2}-\d{2}$") {
            # Create a new entry in the summary for the date if not exists
            $currentDate = $_.Trim()
            if (-not $summary.ContainsKey($currentDate)) {
                $summary[$currentDate] = @{
                    Added = 0
                    Removed = 0
                    Edited = 0
                    Total = 0
                }
            }
        } elseif ($_ -match "\d+ insertions?\(\+\)") {
            # Extract added lines and update the summary
            $inserted = [regex]::Match($_, "\d+ insertions?\(\+\)").Value -replace "[^\d]"
            $summary[$currentDate]["Added"] += [int]$inserted
        } elseif ($_ -match "\d+ deletions?\(-\)") {
            # Extract removed lines and update the summary
            $removed = [regex]::Match($_, "\d+ deletions?\(-\)").Value -replace "[^\d]"
            $summary[$currentDate]["Removed"] += [int]$removed
        }
    }

# Calculate Edited and Total for each date
foreach ($date in $summary.Keys) {
    $summary[$date]["Total"] = $summary[$date]["Added"] + $summary[$date]["Removed"]
}

# Convert to array and display the results as a table
$summary.GetEnumerator() | 
    Sort-Object Name | 
    ForEach-Object { 
        [PSCustomObject]@{
            Date    = $_.Key
            Added   = $_.Value["Added"]
            Removed = $_.Value["Removed"]
            Total   = $_.Value["Total"]
        }
    } | Format-Table -AutoSize

