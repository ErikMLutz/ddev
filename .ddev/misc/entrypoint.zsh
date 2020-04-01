#!/bin/zsh

# symlink all files in .ddev/home
link_dotfiles.zsh $@ || exit 1  # run .ddev/misc/link_dotfiles.zsh

# start empty server
tmux start-server

# get DDev functions and configurations
source ~/.ddev/functions/ddev
source ~/.ddev.conf

# apply default powerline and theme settings
ddev powerline $DDEV_SETTINGS_POWERLINE
ddev theme $DDEV_SETTINGS_THEME 

# set tmux server variable to signal entrypoint completion
tmux set-environment -g DDEV_INITIALIZED "TRUE"

# persistent process to keep container running
tmux wait-for kill-server\; kill-server
