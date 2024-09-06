Param(
    $select = "",
    $do = "fix",
    $branch = "origin/main",
    $args = ""
)

$ErrorActionPreference = "Stop"

if ($do -eq "fix") {
    $args = "$args --show-lint-violations"
}

# Only eval sql files in these paths.
$paths = @("models", "tests", "snapshots")

$failed_files = @()
if ($select.trim() -ne "") {
    Write-Host "select: [$select]"

    $files = @()
    if ($select -eq "failed") {
        Write-Host "Looking for previously failed files"
        $files = Get-Content "./lint_failures.txt"
    } else {
        if ($select -notlike "*.sql*") {
            $select = "$select.sql"
        }

        foreach ($path in $paths) {
            $files += Get-ChildItem -Path $path -Filter "*$select*" -Recurse -File
        }
    }

    if ($files.count -gt 0) {
        Write-Host "Found ($($files.count) files)"
        $files | ForEach-Object {
            Write-Host $_
        }
        $files | ForEach-Object -Begin {$idx = 1} -Process {
            Write-Host "`n$($do)ing $_ ($idx/$($files.count))"
            Invoke-Expression "sqlfluff $do $_ $args" | Tee-Object -Variable sqlfluff_output

            $exit_code = $LASTEXITCODE

            if ($exit_code -ne 0) {
                Write-Host "$_ failed checks ($exit_code)"
                $results += "$_`n$sqlfluff_output"
                $failed_files += $_
            }
            $idx++
        }
    } else {
        Write-Host "No files found using selection provided"
    }

} else {
    $files = & git diff --diff-filter=AMU --name-status $branch .
        | Select-String -Pattern ".*\.sql$"
        | ForEach-Object {$_ -replace '^[A-Z]\s+'}

    # Exclude files not within expected sql paths
    $files = $files | Where-Object {
        $file = $_  # Store current file in a variable for clearer referencing
        $paths | Where-Object { $file -like "$_*" }
    }

    if ($files.count -gt 0) {
        Write-Host "Found $($files.count) files)"
        $files | ForEach-Object {
            Write-Host $_
        }

        $results = @()

        $files | ForEach-Object -Begin {$idx = 1} -Process {
                Write-Host "`n$($do)ing $_ ($idx/$($files.count))"
                Invoke-Expression "sqlfluff $do $_ $args" | Tee-Object -Variable sqlfluff_output

                $exit_code = $LASTEXITCODE

                if ($exit_code -ne 0) {
                    Write-Host "$_ failed checks ($exit_code)"
                    $results += "$_`n$sqlfluff_output"
                    $failed_files += $_
                }
                $idx++
            }
    }
}

# Remove the existing cached failures
if (Test-Path "./lint_failures.txt") {
    Clear-Content "./lint_failures.txt"
} else {
    New-Item -Path "./lint_failures.txt" -ItemType "file" -Force
}
if (($results.count -gt 0)) {
    Write-Host "`nSqlfluff checks returned issues"
    $failed_files | ForEach-Object {
        Write-Host $(Resolve-Path -Path "$_" -Relative)
        # Print the failed files to temp file so they can be used on subsequent runs.
        $(Resolve-Path -Path "$_" -Relative) >> ./lint_failures.txt
    }
    exit 1
} else {
    Write-Host "-----`nAll sqlfluff checks passed"
}
