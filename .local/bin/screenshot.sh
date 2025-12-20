#!/bin/bash

# stolen from: https://seeminglyrandom.net/posts/wayland-screenshot/

mode="$1"

case $mode in
    "region")
        grim -g "$(slurp)" ~/Pictures/Screenshots/Screenshot_$(date +"%Y-%m-%d_%H-%M-%S").png
        ;;
    "window")
        grim -g "$(swaymsg -t get_tree | jq -j '.. | select(.type?) | select(.focused).rect | "\(.x),\(.y) \(.width)x\(.height)"')" ~/Pictures/Screenshots/Screenshot_$(date +"%Y-%m-%d_%H-%M-%S").png
        ;;
    "output")
        grim -o $(swaymsg -t get_outputs | jq -r '.[] | select(.focused) | .name') ~/Pictures/Screenshots/Screenshot_$(date +"%Y-%m-%d_%H-%M-%S").png
        ;;
    "all")
        grim ~/Pictures/Screenshots/Screenshot_$(date +"%Y-%m-%d_%H-%M-%S").png
        ;;
    *)
        echo >&2 "unsupported command \"$mode\""
        echo >&2 "Usage:"
        echo >&2 "screenshot.sh <region|window|output|all>"
        exit 1
esac
