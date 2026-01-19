# Elegant Sketchybar Configuration

A modern, beautiful sketchybar configuration with a Catppuccin-inspired color scheme.

## Features

### Left Side
- **Apple Menu** - Clickable logo with popup menu for:
  - System Preferences
  - Activity Monitor
  - Lock Screen
- **Workspace Indicators** - 10 spaces with beautiful icons
- **Front App** - Shows currently focused application

### Right Side
- **GitHub Notifications** - Shows unread GitHub notifications (requires `gh` CLI)
- **Mail** - Unread mail count from Apple Mail
- **Calendar** - Today's event count (requires `icalBuddy`)
- **Network** - Current WiFi SSID or connection status
- **CPU Usage** - Real-time CPU percentage
- **Memory** - Memory usage percentage
- **Volume** - System volume with dynamic icons
- **Battery** - Battery percentage with color-coded status
- **Clock** - Date and time display

## Color Scheme

The configuration uses a Catppuccin-inspired dark theme:
- Background: Dark charcoal (`0xff1e1e2e`)
- Items: Slightly lighter (`0xff313244`)
- Accent: Soft blue (`0xff89b4fa`)
- Text: Light gray (`0xffcdd6f4`)
- Icons: Color-coded by type (green, yellow, orange, etc.)

## Dependencies

### Required
- [sketchybar](https://github.com/FelixKratz/SketchyBar) - The bar itself
- [SF Pro](https://developer.apple.com/fonts/) - Apple's system font (usually pre-installed)
- A Nerd Font (like [Hack Nerd Font](https://www.nerdfonts.com/)) for icons

### Optional
- [yabai](https://github.com/koekeishiya/yabai) - For workspace switching
- [gh](https://cli.github.com/) - GitHub CLI for notifications
- [icalBuddy](https://github.com/DavidKaluta/icalBuddy) - For calendar events
- [jq](https://stedolan.github.io/jq/) - For JSON parsing (GitHub notifications)

Install optional dependencies:
```bash
brew install gh ical-buddy jq
```

## Installation

1. The configuration is already in place at `~/.config/sketchybar/`

2. Make sure sketchybar is installed:
```bash
brew install sketchybar
```

3. Start sketchybar:
```bash
brew services start sketchybar
```

4. Reload the configuration:
```bash
sketchybar --reload
```

## Customization

### Changing Colors
Edit the color variables at the top of `sketchybarrc`:
```bash
export BAR_COLOR=0xff1e1e2e
export ACCENT_COLOR=0xff89b4fa
# etc...
```

### Modifying Workspace Icons
Edit the `SPACE_ICONS` array in `sketchybarrc`:
```bash
SPACE_ICONS=("" "󰈹" "" "" "󰇰" "󰊻" "󰙯" "" "" "󰎈")
```

### Removing Items
Comment out the item you don't want in `sketchybarrc`:
```bash
# sketchybar --add item github right \
#   --set github ...
```

### Adding New Items
Follow the pattern in `sketchybarrc`:
```bash
sketchybar --add item myitem right \
  --set myitem \
  icon=󰋜 \
  icon.color=$GREEN \
  background.color=$ITEM_BG_COLOR \
  script="$PLUGIN_DIR/myitem.sh"
```

## Font Setup

If icons don't display correctly:

1. Install a Nerd Font:
```bash
brew tap homebrew/cask-fonts
brew install font-hack-nerd-font
```

2. Update the font in `sketchybarrc`:
```bash
icon.font="Hack Nerd Font:Semibold:15.0"
```

## Troubleshooting

### Bar doesn't appear
```bash
# Check if sketchybar is running
ps aux | grep sketchybar

# Restart sketchybar
brew services restart sketchybar
```

### Plugins not working
```bash
# Make sure scripts are executable
chmod +x ~/.config/sketchybar/plugins/*.sh

# Check script errors
~/.config/sketchybar/plugins/cpu.sh
```

### GitHub notifications not showing
```bash
# Authenticate with GitHub CLI
gh auth login

# Test the script
~/.config/sketchybar/plugins/github.sh
```

## Resources

- [Sketchybar Documentation](https://felixkratz.github.io/SketchyBar/)
- [Nerd Fonts Icons](https://www.nerdfonts.com/cheat-sheet)
- [SF Symbols](https://developer.apple.com/sf-symbols/)

## Credits

Inspired by the sketchybar community and Catppuccin color scheme.
