# Import the contents of another just file. The "?" represents optional and will not produce an error.  
import? 'justfile.me'

# Cross platform shebang:
shebang := if os() == 'windows' {
  'pwsh.exe'
} else {
  '/usr/bin/env pwsh'
}

# Use the workspace .env
# We need this so the sessions created
# by the justfile have the same env vars.
set dotenv-load

set windows-shell := ["pwsh", "-NoLogo", "-NoProfileLoadTime", "-Command"]


# [RECIPES]
# setup the project dependencies
@setup:
  $ErrorActionPreference = "Stop"

  # Need to check for uv installation and install here if needed.

  # Evaluates to false if set; otherwise, sets root
  uv venv --python 3.12.10 --allow-insecure-host https://github.com

  # Activate the venv
  Invoke-Expression "$($env:VENV_DIR)\Scripts\activate.ps1"

  # Install deps
  uv pip install -r requirements-dev.txt --native-tls

@test:
  if ($true) {\
    Write-Host 'test';\
    Write-Host 'test2';\
  }

# List files that are changed between current branch and remote main
@ls:
  git -c core.safecrlf=false diff --diff-filter=AMU --name-status origin/main . | ForEach-Object {$_ -replace '^[A-Z]\s+'}

# [SQLFLUFF]

# Run sqlfluff fix with a provided string to wildcard search.
@fix select:
  ./sqlfluff.ps1 -do fix -select {{select}}
alias f := fix

# Run sqlfluff lint with a provided string to wildcard search.
@lint select:
  ./sqlfluff.ps1 -do lint -select {{select}}
alias l := lint

# Run sqlfluff fix on files modified between current branch and main.
@fix_changed:
  ./sqlfluff.ps1 -do fix
alias fc := fix_changed

# Run sqlfluff lint on files modified between current branch and main.
@lint_changed:
  ./sqlfluff.ps1 -do lint
alias lc := lint_changed

# Run sqlfluff fix on the cached failed files from previous run.
@fix_failed:
  ./sqlfluff.ps1 -do fix -select failed
alias ff := fix_failed

# Run sqlfluff lint on the cached failed files from previous run.
@lint_failed:
  ./sqlfluff.ps1 -do lint -select failed
alias lf := lint_failed

# Print the local run_results.json to PS table.
@results:
  $json = Get-Content -Path "./target/run_results.json" -Raw | ConvertFrom-Json; \
  $results = $json.results | \
    Where-Object { $_.relation_name } | \
    Sort-Object -Property execution_time | \
    ForEach-Object { \
      if ($_.unique_id.startswith("test")) { \
        $type = "test" \
      } else { \
        $type = "model" \
      } \
      [PSCustomObject]@{ \
        run_time_sec    = [math]::Round($_.execution_time, 2); \
        run_time_min    = [math]::Round($_.execution_time / 60, 2); \
        status          = $_.status; \
        rows_affected   = $_.adapter_response.rows_affected; \
        type            = $type; \
        node_name       = $_.relation_name; \
        query_id        = $_.adapter_response.query_id; \
      } \
    }; \
  $results \
    | Sort-Object \
      @{Expression={$_.type}; Descending=$false}, \
      @{Expression={$_.status} ;Descending=$false}, \
      @{Expression={$_.run_time_sec} ;Descending=$false} | \
    Format-Table -AutoSize; \
  $invocation_command = $json.args.invocation_command; \
  Write-Output "invocation_command: $invocation_command"

# Run dbt-osmosis for all changes models.
@osmosis:
  Invoke-Expression "$($env:VENV_DIR)\Scripts\activate.ps1"
  dbt-osmosis yaml refactor $($(just ls) | Where-Object {$_ -like 'models/*.sql'}) --auto-apply --skip-merge-meta --output-to-lower



