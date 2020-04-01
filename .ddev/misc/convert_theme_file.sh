#!/bin/bash

theme_file_name=$(basename $1 | sed 's/base16-//g')

head -n 30 $1 | sed '
  s/color_foreground/FOREGROUND_COLOR/g;
  s/color_background/BACKGROUND_COLOR/g;
  s/color00/COLOR_01/g;
  s/color01/COLOR_02/g;
  s/color02/COLOR_03/g;
  s/color03/COLOR_04/g;
  s/color04/COLOR_05/g;
  s/color05/COLOR_06/g;
  s/color06/COLOR_07/g;
  s/color07/COLOR_08/g;
  s/color08/COLOR_09/g;
  s/color09/COLOR_10/g;
  s/color10/COLOR_11/g;
  s/color11/COLOR_12/g;
  s/color12/COLOR_13/g;
  s/color13/COLOR_14/g;
  s/color14/COLOR_15/g;
  s/color15/COLOR_16/g;
  s/color16/COLOR_17/g;
  s/color17/COLOR_18/g;
  s/color18/COLOR_19/g;
  s/color19/COLOR_20/g;
  s/color20/COLOR_21/g;
  s/color21/COLOR_22/g;
  s#/##g;
  s/="/="#/g' > /ddev/themes/$theme_file_name

echo 'CURSOR_COLOR=$FOREGROUND_COLOR' >> /ddev/themes/$theme_file_name
echo "PROFILE_NAME=\"$(echo $theme_file_name | sed s/\\.sh//g)\"" >> /ddev/themes/$theme_file_name
unset theme_file_name
