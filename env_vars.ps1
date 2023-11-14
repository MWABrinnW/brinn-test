Param(
    [Parameter(Mandatory=$false)][string]$env_file='.env'
)

Write-Host "Using $env_file"

# Check if the file exists
if (-Not (Test-Path $env_file)) {
    Write-Error "The file $env_file does not exist."
    return
}


# Read the file and process it line by line
Get-Content "$env_file" | ForEach-Object {
    # Trim the line to remove any leading or trailing whitespaces
    $line = $_.Trim()

    # Skip if the line is a comment or blank
    if ($line.StartsWith("#") -or $line -eq "") {
        return
    }

    # Split the line into name and value by the first '='
    $parts = $line -split '=', 2

    # Check if there are at least two parts (name and value)
    if ($parts.Count -eq 2) {
        $name = $parts[0].Trim()
        $value = $parts[1].Trim()

        # Check if the variable name is valid
        if ($name -match "^\w+$") {
            # Set the environment variable in the current session
            Set-Item Env:$($name) "$value"
            Write-Host "Loaded $name=$value"
        }
        else {
            Write-Warning "Ignored invalid environment variable name: $name"
        }
    }
    else {
        Write-Warning "Ignored malformed line: $_"
    }
}

Get-ChildItem env:* | sort-object name | Where-Object -property name -like "DBT*"
