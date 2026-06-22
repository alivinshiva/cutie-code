#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/alivinshiva/cutie-code.git"

# ── Detect mode: piped via curl or run locally ──────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd 2>/dev/null || true)"
if [[ -f "$SCRIPT_DIR/settings.json" ]]; then
  DOTFILES_DIR="$SCRIPT_DIR"
else
  echo "==> Downloading cutie-code from $REPO_URL"
  DOTFILES_DIR="$(mktemp -d)"
  git clone --depth=1 "$REPO_URL" "$DOTFILES_DIR"
fi

echo "==> Installing cutie-code VS Code setup from $DOTFILES_DIR"

# ── Detect platform ──────────────────────────────────────────────────────────
if [[ "$(uname)" == "Darwin" ]]; then
  OS="mac"
  if ! command -v brew &>/dev/null; then
    echo "==> Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    if [[ -f /opt/homebrew/bin/brew ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
  fi
else
  OS="linux"
fi

# ── Install Fira Code font ───────────────────────────────────────────────────
if [[ "$OS" == "mac" ]]; then
  if ! fc-list 2>/dev/null | grep -qi "fira code"; then
    echo "==> Installing Fira Code font..."
    brew install --cask font-fira-code 2>/dev/null || true
  fi
fi

# ── Install VS Code CLI if missing ──────────────────────────────────────────
if ! command -v code &>/dev/null; then
  echo "==> Installing VS Code CLI..."
  if [[ "$OS" == "mac" ]]; then
    brew install --cask visual-studio-code 2>/dev/null || true
  fi
fi

# ── Install VS Code extensions ───────────────────────────────────────────────
if command -v code &>/dev/null; then
  echo "==> Installing VS Code extensions..."
  code --install-extension catppuccin.catppuccin-vsc --force
  code --install-extension esbenp.prettier-vscode --force
  echo "   Note: iconTheme is 'Monokai Pro Icons' (paid) — install from marketplace if desired"
else
  echo "   ⚠️  VS Code CLI not found. Install VS Code first, then re-run."
fi

# ── Backup existing settings ─────────────────────────────────────────────────
VSCODE_SETTINGS_DIR="$HOME/Library/Application Support/Code/User"
if [[ "$OS" != "mac" ]]; then
  VSCODE_SETTINGS_DIR="$HOME/.config/Code/User"
fi

if [[ -f "$VSCODE_SETTINGS_DIR/settings.json" ]]; then
  BACKUP="$VSCODE_SETTINGS_DIR/settings.json.backup.$(date +%Y%m%d%H%M%S)"
  echo "==> Backing up existing settings to $BACKUP"
  cp "$VSCODE_SETTINGS_DIR/settings.json" "$BACKUP"
fi

# ── Write settings ───────────────────────────────────────────────────────────
echo "==> Writing VS Code settings..."
mkdir -p "$VSCODE_SETTINGS_DIR"
cp "$DOTFILES_DIR/settings.json" "$VSCODE_SETTINGS_DIR/settings.json"

echo ""
echo "✅ Cutie Code installed! Restart VS Code to see the changes."
echo "   Old settings backed up as settings.json.backup.*"
