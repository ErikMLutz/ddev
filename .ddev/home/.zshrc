# ==================================================================================================
# 
#                                              .zshrc
#
# ==================================================================================================

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block, everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# use a custom TERM configuration
export TERM=xterm-24bit

# set neovim as default editor
export EDITOR=nvim

# add DDev commands to path
export PATH=~/.ddev/bin:$PATH

# used DDev's syntax highlighted pager for man files
export MANPAGER="batman"

# less options
export LESS="-aiqrR --mouse"

# add DDev function completions, deduplicate path
export fpath=(~/.ddev/completion $fpath)
typeset -aU fpath

# --------------------------------------------------------------------------------------------------
#                                      oh-my-zsh configuration 
# --------------------------------------------------------------------------------------------------

export ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(
  wd
  git
  docker
  docker-compose
  git-flow
  pip
  per-directory-history
  python
  virtualenv
  vi-mode
)

# source oh-my-zsh once to avoid slow downs
[ -z $ZSHRC_SOURCED ] && source $ZSH/oh-my-zsh.sh

# --------------------------------------------------------------------------------------------------
#                                          zsh configuration 
# --------------------------------------------------------------------------------------------------

# configure zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=$COLOR_21,bg=$BACKGROUND_COLOR"
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_CLEAR_WIDGETS=(expand-or-complete $ZSH_AUTOSUGGEST_CLEAR_WIDGETS)
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
ZSH_AUTOSUGGEST_USE_ASYNC=1

# configure zsh-syntax-highlighting to show brackets
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# enable short option stacking with docker autosuggestions (e.g. autocomplete after '-it')
zstyle ":completion:*:*:docker:*" option-stacking yes
zstyle ":completion:*:*:docker-*:*" option-stacking yes

# source autosuggestions and syntax highlighting
[ -z $ZSHRC_SOURCED ] && source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
[ -z $ZSHRC_SOURCED ] && source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# source function to toggle per directory history using ^g
source $ZSH/plugins/per-directory-history/per-directory-history.zsh

# stop pasted text from being highlighted
zle_highlight=("paste:none")

# disable autosuggestions while pasting, this greatly speeds up how fast pasted
# text can be inserted in the line. This also fixes an issue where annoying and wrong
# autosuggestsion will be displayed after pasting in text
paste_init() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}

paste_finish() {
  zle -N self-insert $OLD_SELF_INSERT
  unset OLD_SELF_INSERT
}
zstyle ":bracketed-paste-magic" paste-init paste_init
zstyle ":bracketed-paste-magic" paste-finish paste_finish

# --------------------------------------------------------------------------------------------------
#                                              DDev 
# --------------------------------------------------------------------------------------------------

# source internal ddev utility and extra utilites
source ~/.ddev/functions/ddev
source ~/.ddev/functions/fzf-extensions

# run ddev initialization only once, NB this needs to be run prior to anything that requires
# DDev's color variables, e.g. FZF_DEFAULT_OPTS and ~/.p10k.zsh
[ -z $ZSHRC_SOURCED ] && ddev init

# establish precmd function
precmd () {
  # sync theme to account for changes from other panes
  ddev theme sync
}

# --------------------------------------------------------------------------------------------------
#                                               fzf 
# --------------------------------------------------------------------------------------------------

export FZF_DEFAULT_OPTS="\
  --reverse --cycle \
  --bind change:top \
  --color bg:${BACKGROUND_COLOR/default/-1},bg+:$COLOR_01 \
  --color fg:${FOREGROUND_COLOR/default/-1},fg+:$COLOR_08 \
  --color hl:$COLOR_07,hl+:$COLOR_07 \
  --color info:$COLOR_05,prompt:$COLOR_05 \
  --color pointer:$COLOR_05,marker:$COLOR_05 \
  --color header:$COLOR_16,spinner:$COLOR_07 \
  --color border:${FOREGROUND_COLOR/default/-1} \
  --color preview-fg:${FOREGROUND_COLOR/default/-1} \
  --color preview-bg:${BACKGROUND_COLOR/default/-1} \
  "
export FZF_DEFAULT_COMMAND='rg --files --hidden'

# source fzf zsh extensions
source "/ddev/fzf/shell/completion.zsh"
source "/ddev/fzf/shell/key-bindings.zsh"

# --------------------------------------------------------------------------------------------------
#                                           miscellaneous 
# --------------------------------------------------------------------------------------------------

# source z functions
[[ -r "/usr/share/z/z.sh" ]] && source /usr/share/z/z.sh

# hook direnv into shell
eval "$(direnv hook zsh)"

# set Neovim to listen to /tmp/nvim so that commands can be sent to all Neovim instances
alias nvim="NVIM_LISTEN_ADDRESS=/tmp/nvim nvim"

# apply p10k theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# don't share history between terminals
unsetopt sharehistory

# signal to skip certain commands on subsequent runs
export ZSHRC_SOURCED="TRUE"

[ -e ~/.zshrc.local ] || [ -L ~/.zshrc.local ] && source ~/.zshrc.local
