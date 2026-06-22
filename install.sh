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

# ── Install all VS Code extensions from list ────────────────────────────────
if command -v code &>/dev/null; then
  echo "==> Installing VS Code extensions..."
  if [[ -f "$DOTFILES_DIR/extensions.txt" ]]; then
    while IFS= read -r ext; do
      [[ -z "$ext" || "$ext" == \#* ]] && continue
      code --install-extension "$ext" --force
    done < "$DOTFILES_DIR/extensions.txt"
  fi
  echo "   Done."
else
  echo "   ⚠️  VS Code CLI not found. Install VS Code first, then re-run."
fi

# ── Backup existing configs ────────────────────────────────────────────────
VSCODE_SETTINGS_DIR="$HOME/Library/Application Support/Code/User"
if [[ "$OS" != "mac" ]]; then
  VSCODE_SETTINGS_DIR="$HOME/.config/Code/User"
fi

TIMESTAMP=$(date +%Y%m%d%H%M%S)

if [[ -f "$VSCODE_SETTINGS_DIR/settings.json" ]]; then
  BACKUP="$VSCODE_SETTINGS_DIR/settings.json.backup.$TIMESTAMP"
  echo "==> Backing up existing settings to $BACKUP"
  cp "$VSCODE_SETTINGS_DIR/settings.json" "$BACKUP"
fi

if [[ -f "$VSCODE_SETTINGS_DIR/keybindings.json" ]]; then
  BACKUP_KEYS="$VSCODE_SETTINGS_DIR/keybindings.json.backup.$TIMESTAMP"
  echo "==> Backing up existing keybindings to $BACKUP_KEYS"
  cp "$VSCODE_SETTINGS_DIR/keybindings.json" "$BACKUP_KEYS"
fi

# ── Write settings & keybindings ────────────────────────────────────────────
echo "==> Writing VS Code settings..."
mkdir -p "$VSCODE_SETTINGS_DIR"
cp "$DOTFILES_DIR/settings.json" "$VSCODE_SETTINGS_DIR/settings.json"

if [[ -f "$DOTFILES_DIR/keybindings.json" ]]; then
  cp "$DOTFILES_DIR/keybindings.json" "$VSCODE_SETTINGS_DIR/keybindings.json"
  echo "==> Keybindings restored."
fi

echo ""
echo "✅ Cutie Code installed! Restart VS Code to see the changes."
echo "   Old configs backed up as *.backup.$TIMESTAMP"
