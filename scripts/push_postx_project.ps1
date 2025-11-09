# Backup home .git, init project repo, commit project files and push to new branch on the existing remote
$home = 'C:\Users\sriva'
$project = 'C:\Users\sriva\OneDrive\Desktop\PostX'
$ts = (Get-Date -Format 'yyyyMMdd-HHmmss')
$backup = Join-Path $home ".git-home-backup-$ts"
Write-Output "Timestamp: $ts"

# 1) Backup home .git if it exists
if (Test-Path (Join-Path $home '.git')) {
    Write-Output "Backing up home .git to: $backup"
    Move-Item -Path (Join-Path $home '.git') -Destination $backup -Force
} else {
    Write-Output "No .git found in home; nothing to back up."
}

# 2) Ensure project path exists
if (-not (Test-Path $project)) {
    Write-Error "Project folder not found: $project"
    exit 1
}

Set-Location $project

# 3) Initialize git repo if missing
if (-not (Test-Path (Join-Path $project '.git'))) {
    Write-Output "Initializing git repository in project: $project"
    git init
} else {
    Write-Output "Project already has a .git directory"
}

# 4) Stage and commit all project files
Write-Output "Staging all files in project"
git add -A

$commitMsg = "Add PostX project backup $ts"
try {
    git commit -m $commitMsg -q
    Write-Output "Committed: $commitMsg"
} catch {
    Write-Output "No changes to commit or commit failed."
}

# 5) Determine remote URL to use: prefer existing origin in home backup's remote info if provided.
$defaultRemote = 'https://github.com/aryansrivastav52/DSA.git'
$remoteToUse = $null

# If a remote 'origin' already exists in this repo use it, else use the default
try {
    $existing = git remote get-url origin 2>$null
    if ($LASTEXITCODE -eq 0 -and $existing) {
        $remoteToUse = $existing.Trim()
        Write-Output "Using existing origin remote: $remoteToUse"
    } else {
        $remoteToUse = $defaultRemote
        Write-Output "No origin found in project; will use default remote: $remoteToUse"
    }
} catch {
    $remoteToUse = $defaultRemote
    Write-Output "No origin found in project; will use default remote: $remoteToUse"
}

# Add remote if missing or different
try {
    $cur = git remote get-url origin 2>$null
    if ($LASTEXITCODE -ne 0) {
        git remote add origin $remoteToUse
        Write-Output "Added origin -> $remoteToUse"
    } else {
        Write-Output "Origin already set to: $cur"
    }
} catch {
    Write-Output "Could not set origin: $_"
}

# 6) Create a new branch and push
$branch = "postx-backup-$ts"
Write-Output "Creating and switching to branch: $branch"
try {
    git checkout -b $branch
} catch {
    Write-Output "Failed to create branch (maybe already exists). Attempting to switch."
    git checkout $branch 2>$null
}

Write-Output "Pushing branch $branch to origin (you may be prompted for credentials)"
try {
    git push -u origin $branch -v
    Write-Output "Push complete"
} catch {
    Write-Output "Push failed: $_"
    exit 2
}

# 7) Print final status and remote info
Write-Output "Final local branches:"; git branch --show-current
Write-Output "Remote branches (origin):"; git ls-remote --heads origin | Select-Object -First 20
Write-Output "Script finished. Backed up home .git to: $backup (if it existed)."
