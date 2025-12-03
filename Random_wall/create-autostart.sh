#!/bin/bash

File="$HOME/.config/autostart/randomwall.desktop"

mkdir -p "$HOME/.config/autostart"

cat > "$File" <<EOF
[Desktop Entry]
Type=Application
Exec=$Home/.local/bin/auto-ranwalls.sh
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Auto Wallpaper
EOF

echo "Autostart entry created at $File"
