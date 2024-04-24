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

if ($select.trim() -ne "") {
    Write-Host "select: [$select]"
    $paths = @("models", "tests")
    $files = @()

    if ($select -notlike "*.sql*") {
        $select = "$select.sql"
    }

    foreach ($path in $paths) {
        $files += Get-ChildItem -Path $path -Filter "*$select*" -Recurse -File
    }

    if ($files.count -gt 0) {
        Write-Host "Found $($files.count) files)"
        $files | ForEach-Object -Begin {$idx = 1} -Process {
            Write-Host "`n$($do)ing $_ ($idx/$($files.count))"
            Invoke-Expression "sqlfluff $do $_ $args" | Tee-Object -Variable sqlfluff_output

            $exit_code = $LASTEXITCODE

            if ($exit_code -ne 0) {
                Write-Host "$_ failed checks ($exit_code)"
                $results += "$_`n$sqlfluff_output"
                $failed_files += $_
            }
        }
    } else {
        Write-Host "No files found using selection provided"
    }

} else {
    $files = & git diff --diff-filter=AMU --name-status $branch .
        | Select-String -Pattern ".*\.sql$"
        | ForEach-Object {$_ -replace '^[A-Z]\s+'}

    if ($files.count -gt 0) {
        Write-Host "Found $($files.count) files)"
        $files | ForEach-Object {
            Write-Host $_
        }

        $results = @()
        $failed_files = @()
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


if (($results.count -gt 0)) {
    Write-Error "`nSqlfluff checks returned issues"
    $failed_files | ForEach-Object {
        Write-Host $_
    }
    exit 1
} else {
    Write-Host "-----`nAll sqlfluff checks passed"
}
