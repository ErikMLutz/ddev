" =============================================================================
" Filename: autoload/lightline/colorscheme/ddev.vim
" Author: Erik Lutz
" =============================================================================

let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}
let s:p.normal.left = [ [$COLOR_01, $COLOR_03], [$COLOR_16, $COLOR_20] ]
let s:p.normal.right = [ [$COLOR_20, $COLOR_22], [$COLOR_22, $COLOR_20] ]
let s:p.normal.middle = [ [ $COLOR_20, $BACKGROUND_COLOR ] ]
let s:p.inactive.left = s:p.normal.left
let s:p.inactive.right = s:p.normal.right
let s:p.inactive.middle = s:p.normal.middle
let s:p.insert.left = [ [$COLOR_01, $COLOR_05], [$COLOR_16, $COLOR_20] ]
let s:p.insert.right = s:p.normal.right
let s:p.insert.middle = s:p.normal.middle
let s:p.replace.left = [ [$COLOR_01, $COLOR_02], [$COLOR_16, $COLOR_20] ]
let s:p.replace.right = s:p.normal.right
let s:p.replace.middle = s:p.normal.middle
let s:p.visual.left = [ [$COLOR_01, $COLOR_04], [$COLOR_16, $COLOR_20] ]
let s:p.visual.right = s:p.normal.right
let s:p.visual.middle = s:p.normal.middle
let s:p.tabline.left = [ [ $COLOR_22, $COLOR_20 ] ]
let s:p.tabline.tabsel = [ [ $COLOR_22, $COLOR_19 ] ]
let s:p.tabline.middle = s:p.normal.middle
let s:p.tabline.right = s:p.tabline.left
let s:p.normal.error = [ [ $COLOR_01, $COLOR_02 ] ]
let s:p.normal.warning = [ [ $COLOR_01, $COLOR_04 ] ]

let g:lightline#colorscheme#ddev#palette = lightline#colorscheme#fill(s:p)
