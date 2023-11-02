#!/usr/bin/bash

# Install the fonts
# stow -t ~/.local/share/fonts -S fonts
# fc-cache -fv

ln -sf $PWD/git $HOME/.config/git
ln -sf $PWD/.vimrc $HOME/.vimrc
ln -sf $PWD/tmux $HOME/.config/tmux

