#!/bin/bash

wall_dir="$HOME/Pictures/wallpapers"

ran_wall=$(find "$wall_dir" -type f | shuf -n 1)

gsettings set org.gnome.desktop.background picture-uri "file://$ran_wall"

gsettings set org.gnome.desktop.background picture-uri-dark "file://$ran_wall"
