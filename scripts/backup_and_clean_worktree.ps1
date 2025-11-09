$repo = 'C:\Users\sriva\OneDrive\Desktop\PostX'

# get current branch
$orig = git -C $repo rev-parse --abbrev-ref HEAD
$ts = (Get-Date -Format 'yyyyMMdd-HHmmss')
$bk = "backup-changes-$ts"

Write-Output "Creating backup branch: $bk (from $orig)"

# create new branch
git -C $repo checkout -b $bk

# add and commit everything (including untracked)
git -C $repo add -A
try {
    git -C $repo commit -m "WIP backup before discarding changes ($ts)" -q
} catch {
    Write-Output 'No changes to commit or commit failed.'
}

# return to original branch
git -C $repo checkout $orig

# discard all changes and remove untracked/ignored files
git -C $repo reset --hard HEAD
git -C $repo clean -fdx

Write-Output 'Final git status (porcelain):'
git -C $repo status --porcelain | Measure-Object -Line
