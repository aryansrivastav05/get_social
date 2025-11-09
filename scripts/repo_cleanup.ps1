$repo='C:\Users\sriva\OneDrive\Desktop\PostX'
Set-Location $repo
Write-Output "Repo: $pwd"
$items=@('.venv','PostX\.venv','media','PostX\media','sent_emails','PostX\sent_emails')
foreach($i in $items){
    if(Test-Path $i){
        Write-Output "Removing from git index: $i"
        git rm -r --cached $i
    } else {
        Write-Output "Not present: $i"
    }
}
if(Test-Path 'db.sqlite3'){
    Write-Output "Removing db.sqlite3 from index"
    git rm --cached db.sqlite3 -f
}

Write-Output "Staging housekeeping files"
git add .gitignore requirements-dev.txt README.md Procfile runtime.txt requirements.txt 2>$null
Write-Output "Staging all changes"
git add -A

$commitMessage='Cleanup: ignore local envs/media; add dev requirements; configure whitenoise and DATABASE_URL'
try {
    git commit -m $commitMessage -q
    Write-Output "Committed: $commitMessage"
} catch {
    Write-Output "Nothing to commit or commit failed"
}

Write-Output "Pushing to origin HEAD"
try {
    git push origin HEAD -v
} catch {
    Write-Output "Push failed: $_"
}
