FROM alpine:latest

# set HOME, which is not set by default
ENV HOME /root

# Add edge repositories to apk
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories

# Install Packages
RUN apk add --update-cache --no-cache --quiet \
    man man-pages \
    ncurses ncurses-doc \
    util-linux util-linux-doc \
    bash \
    zsh zsh-vcs zsh-autosuggestions zsh-syntax-highlighting\
    oh-my-zsh \
    curl curl-doc \
    git git-doc \
    subversion subversion-doc \
    neovim neovim-doc \
    tmux tmux-doc \
    perl \
    docker docker-doc \
    fzf fzf-tmux fzf-zsh-completion fzf-neovim fzf-doc \
    bat bat-doc \
    less less-doc \
    ripgrep ripgrep-doc \
    direnv direnv-doc \
    fd fd-doc \
    tree tree-doc \
    z z-doc

# Copy source files to ~/.ddev
COPY .ddev $HOME/.ddev

# add default versions of config files, will be overwritten by entrypoint script
RUN for object in $(ls -a $HOME/.ddev/home | sed 1,2d); do ln -sf $HOME/.ddev/home/$object $HOME/$(basename $object); done

# add entrypoint to bin
COPY .ddev/misc/entrypoint.zsh /bin/entrypoint.zsh
RUN chmod +x /bin/entrypoint.zsh

# Install git-flow
RUN sh -c "$(curl -fsSL https://raw.github.com/nvie/gitflow/develop/contrib/gitflow-installer.sh)"

# oh-my-zsh installed via apk so set non standard directory (usually ~/.oh-my-zsh)
ENV ZSH=/usr/share/oh-my-zsh
ENV ZSH_CUSTOM=$ZSH/custom

# Install Powerlevel10k
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k

# Install terminfo configuration
RUN tic -x -o $HOME/.terminfo $HOME/.ddev/misc/xterm-24bit.terminfo
ENV TERM=xterm-24bit

# clone themes from Mayccoll's Gogh repository
RUN svn export https://github.com/Mayccoll/Gogh/trunk/themes $HOME/.themes

# Install Vim-Plug and run PlugInstall
RUN curl -fLo $HOME/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
RUN nvim -c "PlugInstall | qa"

# set locale so that tmux opens using proper font
ENV LANG=en_US.UTF-8

ENTRYPOINT ["entrypoint.zsh"]
