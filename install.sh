#!/usr/bin/env bash

# Fetch
git clone --recursive https://github.com/Szkered/dotfiles.git ~/.dotfiles

# Set Flag
FLAG='-fns'

# Emacs
if [ ! -d "~/.emacs.d" ]; then
    mkdir ~/.emacs.d
fi
ln $FLAG ~/.dotfiles/emacs/init.el ~/.emacs.d/init.el
ln $FLAG ~/.dotfiles/emacs/themes/ ~/.emacs.d/themes

# Tmux
ln $FLAG ~/.dotfiles/tmux/tmux.conf ~/.tmux.conf
