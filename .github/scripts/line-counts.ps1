$since_date = "2023-01-01"

git log --format='%aN' --since=$since_date | Sort-Object -Unique | ForEach-Object {
    $name = $_
    $addedLines = 0
    $removedLines = 0
    (git log --author="$name" --pretty=tformat: --numstat --since=$since_date) | ForEach-Object {
        if ($_ -match '(\d+)\s+(\d+)') {
            $addedLines += [int]$matches[1]
            $removedLines += [int]$matches[2]
        }
    }
    [PSCustomObject]@{
        Author = $name
        AddedLines = $addedLines
        RemovedLines = $removedLines
        TotalLines = $addedLines - $removedLines
    }
} | Format-Table -AutoSize
