<#
  deploy.ps1 - create a GitHub repository for the course site and push it.
  Vercel then deploys it when you import the repo (and on every later push).

  Usage (from this folder, in PowerShell):
    .\deploy.ps1 -Owner Cautiouszeal1
    .\deploy.ps1 -Owner Cautiouszeal1 -Repo aws-devops-course -Private

  Needs: git. Optional: GitHub CLI (gh), signed in with `gh auth login`.
  Without gh, create an EMPTY repo on github.com first, then run this script.
#>
param(
  [Parameter(Mandatory = $true)][string]$Owner,
  [string]$Repo = "aws-devops-course",
  [switch]$Private
)
$ErrorActionPreference = "Stop"

if (-not (Get-Command git -ErrorAction SilentlyContinue)) { throw "git is not installed. Install Git for Windows, then run this again." }

$email = (git config user.email)
$name  = (git config user.name)
if (-not $email -or -not $name) { throw "Set your git identity first: git config --global user.name ""Your Name""; git config --global user.email ""you@example.com""" }
Write-Host "Commits will be authored as: $name <$email>"
Write-Host "Vercel can block deploys when this email does not belong to the GitHub account '$Owner'. Press Ctrl+C now to stop if it is wrong." -ForegroundColor Yellow
Start-Sleep -Seconds 5

if (-not (Test-Path ".git")) { git init -b main | Out-Null }
git add -A
$pending = git status --porcelain
if ($pending) { git commit -m "Course website: initial version" | Out-Null }

$remote = "https://github.com/$Owner/$Repo.git"
$hasGh = [bool](Get-Command gh -ErrorAction SilentlyContinue)

if ($hasGh) {
  $visibility = if ($Private) { "--private" } else { "--public" }
  gh repo view "$Owner/$Repo" 2>$null | Out-Null
  if ($LASTEXITCODE -ne 0) {
    Write-Host "Creating $Owner/$Repo on GitHub..."
    gh repo create "$Owner/$Repo" $visibility --source . --remote origin --push
  } else {
    if (-not (git remote 2>$null | Select-String -Quiet "^origin$")) { git remote add origin $remote }
    git push -u origin main
  }
} else {
  Write-Host "GitHub CLI not found. Make sure https://github.com/$Owner/$Repo exists and is EMPTY, then press Enter."
  Read-Host | Out-Null
  if (-not (git remote 2>$null | Select-String -Quiet "^origin$")) { git remote add origin $remote }
  git push -u origin main
}

Write-Host ""
Write-Host "Pushed to $remote" -ForegroundColor Green
Write-Host "Next: vercel.com -> Add New -> Project -> Import '$Repo' -> Framework preset 'Other' -> Deploy."
