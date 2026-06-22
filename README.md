# Cutie Code 🎀

A beautiful **Catppuccin Mocha** VS Code setup with **transparency**, **blur**, and a ghosty terminal aesthetic.

| Preview | |
|---|---|
| ![Editor](https://raw.githubusercontent.com/alivinshiva/cutie-code/master/editor.png) | ![Terminal](https://raw.githubusercontent.com/alivinshiva/cutie-code/master/terminal.png) |
| ![Explorer](https://raw.githubusercontent.com/alivinshiva/cutie-code/master/explorer.png) | |

## Features ✨

- **Catppuccin Mocha** theme — warm dark color palette
- **Window transparency & blur** — see your desktop wallpaper through the editor
- **Ghosty terminal** — fully transparent terminal background
- **Fira Code font** with ligatures — clean coding experience
- **Smooth cursor** — smooth caret animation with blinking
- **Smart auto-save** — saves 500ms after you stop typing
- **Git integration** — auto-fetch & smart commit enabled
- **Prettier** as default formatter for JS/TS/CSS/JSON
- **Word wrap** enabled by default
- **Mouse wheel zoom** — Ctrl+Scroll to zoom in/out
- **Terminal** — 20px bold font with GPU acceleration disabled for transparency compatibility

## Preview 👀

| Element | Color |
|---|---|
| Editor background | `#1e1e2e` at 30% opacity |
| Sidebar | `#1e1e2e` at 30% opacity |
| Terminal | Fully transparent |
| Widgets/Dropdowns | `#1e1e1e` at 90% opacity |
| Tabs | Fully transparent |
| Title bar | `#1e1e2e` at 80% opacity |

## Installation 🚀

### One-liner (recommended)

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/alivinshiva/cutie-code/master/install.sh)"
```

This will:
1. Backup your existing VS Code settings
2. Install Fira Code font (macOS via Homebrew)
3. Install Catppuccin Mocha theme & Prettier extensions
4. Apply the complete configuration

### Manual

1. Install extensions:
   - [Catppuccin for VS Code](https://marketplace.visualstudio.com/items?itemName=catppuccin.catppuccin-vsc)
   - [Prettier](https://marketplace.visualstudio.com/items?itemName=esbenp.prettier-vscode)
2. Set font to `Fira Code` (install from [Nerd Fonts](https://www.nerdfonts.com/))
3. Copy `settings.json` to your VS Code user config:
   - macOS: `~/Library/Application Support/Code/User/settings.json`
   - Linux: `~/.config/Code/User/settings.json`
   - Windows: `%APPDATA%\Code\User\settings.json`

## Requirements 📋

- **VS Code** 1.96+ (for native transparency support)
- **macOS**: Window blur requires custom title bar (auto-configured)
- **Fira Code** font (auto-installed on macOS)

## Notes 📝

- The icon theme is set to **Monokai Pro Icons** (paid extension). To use a free alternative, change `workbench.iconTheme` to `material-icon-theme` and install [Material Icon Theme](https://marketplace.visualstudio.com/items?itemName=PKief.material-icon-theme).
- Transparency requires VS Code 1.96+. On older versions, use the [Vibrancy Continued](https://marketplace.visualstudio.com/items?itemName=illixion.vscode-vibrancy-continued) extension instead.
- If transparency doesn't work on macOS, check that `window.titleBarStyle` is set to `custom`.

## Customization 🎨

Edit `~/.config/Code/User/settings.json` and adjust the alpha values in `workbench.colorCustomizations`:
- `#1e1e2e4d` = 30% opacity
- `#1e1e2ecc` = 80% opacity
- `#1e1e1ee6` = 90% opacity
- `#1e1e1e00` = 100% transparent
- `#00000000` = fully transparent (terminal)

## Revert ↩️

Your old settings are backed up as `settings.json.backup.<timestamp>`. To restore:

```bash
cp ~/Library/Application\ Support/Code/User/settings.json.backup.* \
   ~/Library/Application\ Support/Code/User/settings.json
```
