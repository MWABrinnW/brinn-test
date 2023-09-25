Param(
    $command = "$env:DBT_COMMAND",
	$target = "$env:DBT_TARGET",
    $branch = "$env:DBT_BRANCH",
    $repo_url = "$env:DBT_REPO_URL",
	$repo_name = "$env:DBT_REPO_NAME",
    $output_dir = "$env:DBT_STATE",
    $use_defer = [int]"$env:DBT_USE_DEFER",
	$skip_upload = [int]"$env:DBT_SKIP_UPLOAD"
)

$ErrorActionPreference = "Stop"

[string]$chat_id = $env:WP_CHAT_ID
[string]$wp_token = $env:WP_TOKEN

function post_to_workplace {
	Param($wp_token, $message, $chat_id)

	# Use this format to send to an existing chat thread 'https://graph.workplace.com/v17.0/me/messages'
	# text can't be longer than 2000 characters
    $postParams = ConvertTo-Json @{
        message = @{text = [string]$message}
		access_token = $wp_token
		recipient = @{thread_key = $chat_id}
    }
    $response = Invoke-WebRequest `
        -Uri "https://graph.workplace.com/me/messages" `
        -Method "POST" `
        -ContentType 'application/json' `
        -Body $postParams	
}


Write-Host 'Upstream ID: ${-@ID}'
Write-Host 'Upstream TemplateID: ${-@TemplateID}'
Write-Host 'Upstream Name: ${-@Name}'
Write-Host 'Upstream Label: ${-@Label}'
Write-Host 'Upstream Path: ${-@Path}'
Write-Host 'This ID: ${@ID}'
Write-Host 'This TemplateID: ${@TemplateID}'
Write-Host 'This Name: ${@Name}'
Write-Host 'This Label: ${@Label}'
Write-Host 'This Path: ${@Path}'

$working_dir = '${working_dir}'
$reset_tmp_dir = '${reset_tmp_dir}'
$upstream_label = '${-@Name}'
$label = '${@Label}'
$template_id = '${@TemplateID}'

# Set dbt command
$expression = "dbt $command"
if ($use_defer -eq 1) {
    $expression += " --defer"
}
$expression += " --target=$target"
Write-Host "dbt command: '$expression'"

# Set temp dir
if ($working_dir -ne '') {
	$tmp_dir = $working_dir
} else {
	if ($upstream_label -ne '' -and $no_upstream -ne '1'){
		$tmp_dir = "$($upstream_label)__$($label)__$($template_id)"
	} else {
		$tmp_dir = "$($label)__$($template_id)"
	}
}

# Reset temp dir
if ($reset_tmp_dir -eq '1') {
	if (test-path "$tmp_dir") {
		Write-Host "Removing existing tmp directory $tmp_dir"
		Remove-Item "$tmp_dir" -Force -Recurse
	} else {
		Write-Host "No existing directory to remove"
	}
}

# Create temp dir
if (!(Test-Path -Path "$tmp_dir")) {
	Write-Host "Creating tmp directory as '$tmp_dir'"
	New-Item -ItemType Directory -Path "$tmp_dir"
}

Write-Host "Setting tmp directory as $tmp_dir"
Set-Location "$tmp_dir"

# Activate venv
$venv = 'venv'
Write-Host "Activating python venv"
& python -m venv $venv
& $venv/Scripts/activate
& python --version
Write-Host "venv path $env:VIRTUAL_ENV"

if ($LASTEXITCODE -gt 0) {throw "Error with requirements install"}

# Clone repository
# & start-ssh-agent
if (!(Test-Path -Path $repo_name)) {
	Write-Host "Cloning repo"
	& git clone $repo_url $repo_name
}

$execution_timestamp = Get-Date -Format "yyyy-MM-dd_HH.mm.ss"

Set-Location $repo_name
# Checkout branch
& git switch $branch
& git pull origin $branch

Write-Host "Installing requirements from repo requirements.txt"
& pip install -r requirements.txt

# Setup dbt dependencies
Write-Host "Executing 'dbt deps'"
& dbt deps

# Execute dbt command
Write-Host "Executing '$expression'"
[array]$dbt_output = $null
Invoke-Expression $expression | Tee-Object -Variable dbt_output # Put the output into a variable but still send to stdout

$dbt_exit_code = $LASTEXITCODE

Write-Host "dbt exit code: $dbt_exit_code"

# Related | https://www.datafold.com/blog/accelerating-dbt-core-ci-cd-with-github-actions-a-step-by-step-guide
# Upload artificates | https://docs.getdbt.com/reference/artifacts/dbt-artifacts
# MANIFEST.JSON | https://docs.getdbt.com/reference/artifacts/manifest-json
# Upload manifest to shared location
if ($skip_upload -ne 1) {
	Write-Host "Copying manifest.json to $output_dir"
	Copy-Item "./target/manifest.json" -Destination "$output_dir" -Force

	# RUN_RESULTS.JSON | https://docs.getdbt.com/reference/artifacts/run-results-json
	if (Test-Path -Path "./target/run_results.json" -PathType leaf) {
		Write-Host "Copying run_results.json to $output_dir"
		# Upload sources.json to shared location
		Copy-Item "./target/run_results.json" -Destination "$output_dir" -Force
	} else {
		Write-Host "No run_results.json found"
	}

	# SOURCES.JSON | https://docs.getdbt.com/reference/artifacts/sources-json
	if (Test-Path -Path "./target/sources.json" -PathType leaf) {
		Write-Host "Copying sources.json to $output_dir"
		# Upload sources.json to shared location
		Copy-Item "./target/sources.json" -Destination "$output_dir" -Force
	} else {
		Write-Host "No sources.json found"
	}
}

# Determine if anything was attempted to be built
if (($dbt_output | %{$_.contains('Nothing to do.')}) -contains $true) {
	Write-Host "dbt did not build anything."
} else {
	$payload = $dbt_output
	# Post alert
	# post_to_workplace -wp_token $wp_token -message $payload -chat_id $chat_id
}

# Check dbt execution result
if ($dbt_exit_code -ne 0) {
    Write-Error "`ndbt execution failed with exit code $dbt_exit_code"
    exit 1
} else {
	Write-Host "Completed successfully"
}

