#!/usr/bin/bash

# Install the fonts
stow -t ~/.local/share/fonts -S fonts
fc-cache -fv
