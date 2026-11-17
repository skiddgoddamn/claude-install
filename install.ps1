# Установка всего за 1 команду (Windows 10/11, PowerShell):
#   irm https://raw.githubusercontent.com/skiddgoddamn/claude-install/main/install.ps1 | iex
$ErrorActionPreference = 'Continue'
function Say($t) { Write-Host "`n==> $t" -ForegroundColor Cyan }
function RefreshPath { $env:Path = [Environment]::GetEnvironmentVariable('Path','Machine') + ';' + [Environment]::GetEnvironmentVariable('Path','User') }

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
  Write-Host "Нет winget. Обнови 'App Installer' в Microsoft Store и запусти снова." -ForegroundColor Red; return
}

Say 'Ставлю Node.js, Git и VS Code (может спросить разрешение - жми Да)'
foreach ($id in 'OpenJS.NodeJS.LTS','Git.Git','Microsoft.VisualStudioCode') {
  winget install --id $id -e --silent --accept-source-agreements --accept-package-agreements
}
RefreshPath

Say 'Ставлю Claude Code'
code --install-extension anthropic.claude-code --force
npm install -g @anthropic-ai/claude-code
RefreshPath; $env:Path += ";$env:APPDATA\npm"

Say 'Ставлю плагины'
foreach ($m in 'anthropics/claude-plugins-official','https://github.com/DietrichGebert/ponytail','https://github.com/pbakaus/impeccable','https://github.com/Leonxlnx/taste-skill') {
  claude plugin marketplace add $m
}
foreach ($p in 'superpowers@claude-plugins-official','frontend-design@claude-plugins-official','context7@claude-plugins-official','commit-commands@claude-plugins-official','github@claude-plugins-official','ponytail@ponytail','impeccable@impeccable','taste-skill@taste-skill') {
  claude plugin install $p
}

Say 'Готово! Открой VS Code, нажми значок Claude справа сверху и Sign in.'
