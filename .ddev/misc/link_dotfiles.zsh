#!/bin/zsh
#
# DDev utility that symlinks all dotfiles in /ddev/.ddev/home to their respective locations in ~

local conflict=0
local msg=""
for object in $(find ~/.ddev/home -type f | sed "s#/root/.ddev/home/##g"); do
  if [ -e ~/"$object" ] && [ "$(readlink ~/"$object")" != /root/.ddev/home/"$object" ]; then
    conflict=1
    msg="$msg $object \n"
  fi

  if [ $conflict -eq 0 ]; then  # only perform links of no conflicts are found
    [ ! "$(dirname $object)" = "." ] && mkdir -p ~/"$(dirname $object)"  # make parent directory if necessary
    unlink ~/"$object" > /dev/null 2>&1  # unlink any existing dotfile
    ln -fns ~/.ddev/home/"$object" ~/"$object"  # link in new dotfile
  fi
done

if [ $conflict -eq 1 ]; then
  echo "DDev could not link in its configuration files because some files already exist:\n$msg" 1>&2
  exit 1
fi
