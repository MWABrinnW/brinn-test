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
@setup:
  $ErrorActionPreference = "Stop"
  echo "Setting up your environment..."
  echo "venv_dir=$($env:VENV_DIR)"

  # Create the venv dir
  if (!(Test-Path $env:VENV_DIR)) {\
    New-Item -Path $env:VENV_DIR -ItemType Directory;\
    python -m venv $env:VENV_DIR;\
  }

  # Activate the venv
  Invoke-Expression "$($env:VENV_DIR)/Scripts/Activate.ps1"
  pip install -r requirements-dev.txt
  dbt clean
  dbt deps
  deactivate

@test:
  if ($true) {\
    Write-Host 'test';\
    Write-Host 'test2';\
  }

@ls:
  git diff --diff-filter=AMU --name-status origin/main . | ForEach-Object {$_ -replace '^[A-Z]\s+'}

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
