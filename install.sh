#!/usr/bin/env bash
# Установка всего за 1 команду (macOS):
#   curl -fsSL https://raw.githubusercontent.com/skiddgoddamn/claude-install/main/install.sh | bash
set -u

say() { printf '\n\033[1;36m==> %s\033[0m\n' "$1"; }

[ "$(uname)" = "Darwin" ] || { echo "Этот скрипт для macOS. Для Windows: install.ps1"; exit 1; }

# 1. Homebrew (менеджер программ для Mac)
if ! command -v brew >/dev/null 2>&1; then
  say "Ставлю Homebrew (попросит пароль от Mac — это нормально, символы не видны)"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" </dev/tty
fi
for p in /opt/homebrew/bin/brew /usr/local/bin/brew; do [ -x "$p" ] && eval "$("$p" shellenv)"; done
grep -q 'brew shellenv' ~/.zprofile 2>/dev/null || echo "eval \"\$($(command -v brew) shellenv)\"" >> ~/.zprofile

# 2. Node.js + Git + VS Code
say "Ставлю Node.js, Git и VS Code"
brew install node git
brew list --cask visual-studio-code >/dev/null 2>&1 || [ -d "/Applications/Visual Studio Code.app" ] || brew install --cask visual-studio-code
CODE="/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
command -v code >/dev/null 2>&1 && CODE="code"

# 3. Claude Code: расширение VS Code + терминальная версия
say "Ставлю Claude Code"
"$CODE" --install-extension anthropic.claude-code --force || echo "Расширение поставь вручную: Extensions -> Claude Code"
npm install -g @anthropic-ai/claude-code || sudo npm install -g @anthropic-ai/claude-code

# 4. Плагины
say "Ставлю плагины"
for m in anthropics/claude-plugins-official \
         https://github.com/DietrichGebert/ponytail \
         https://github.com/pbakaus/impeccable \
         https://github.com/Leonxlnx/taste-skill; do
  claude plugin marketplace add "$m" || true
done
for p in superpowers@claude-plugins-official frontend-design@claude-plugins-official \
         context7@claude-plugins-official commit-commands@claude-plugins-official \
         github@claude-plugins-official ponytail@ponytail impeccable@impeccable taste-skill@taste-skill; do
  claude plugin install "$p" || true
done

say "Готово! Открой VS Code, нажми значок Claude справа сверху и Sign in."
open -a "Visual Studio Code" 2>/dev/null || true
