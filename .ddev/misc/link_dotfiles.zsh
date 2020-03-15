#!/bin/zsh
#
# DDev utility that symlinks all dotfiles in ~/.ddev/home to their respective locations in ~

for object in $(find ~/.ddev/home -type f | sed "s#/root/.ddev/home/##g"); do
  [ ! "$(dirname $object)" = "." ] && mkdir -p ~/"$(dirname $object)"  # make parent directory if necessary
  unlink ~/"$object" > /dev/null 2>&1  # unlink any existing dotfile
  ln -fns ~/.ddev/home/"$object" ~/"$object"  # link in new dotfile
done
