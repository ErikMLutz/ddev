#!/bin/zsh

# symlink all files in .ddev/home
for object in ~/.ddev/home/.*; do
  echo $object
  ln -sf $object /root/$(basename $object)
done

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
