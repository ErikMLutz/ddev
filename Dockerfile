FROM alpine:latest

# set HOME, which is not set by default
ENV HOME /root

# create storage directory for DDev resources
RUN mkdir /ddev

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
    file \
    docker docker-doc \
    fzf fzf-tmux fzf-zsh-completion fzf-neovim fzf-doc \
    bat bat-doc \
    less less-doc \
    ripgrep ripgrep-doc \
    direnv direnv-doc \
    fd fd-doc \
    tree tree-doc \
    z z-doc \
    python3

# Install build dependencies
RUN apk add --no-cache --virtual build-deps \
    gcc python3-dev musl-dev

# Install Python packages
RUN pip3 install \
    neovim

# Copy source files to /ddev
COPY .ddev /ddev/.ddev

# add default versions of config files, will be overwritten by entrypoint script
COPY .ddev/misc/link_dotfiles.zsh /bin/link_dotfiles.zsh
RUN chmod +x /bin/link_dotfiles.zsh
RUN link_dotfiles.zsh

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
RUN tic -x /ddev/.ddev/misc/xterm-24bit.terminfo
ENV TERM=xterm-24bit

# clone themes from Chris Kempson's Base-16 repository
RUN svn export https://github.com/chriskempson/base16-shell/trunk/scripts /ddev/themes
RUN for theme in /ddev/themes/*; do /ddev/.ddev/misc/convert_theme_file.sh $theme; done
RUN rm /ddev/themes/base16-*

# Install Vim-Plug and run PlugInstall
RUN curl -fLo $HOME/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
RUN nvim --headless +PlugInstall +qa

# set locale so that tmux opens using proper font
ENV LANG=en_US.UTF-8

# Remove build dependencies
RUN apk del build-deps

ENTRYPOINT ["entrypoint.zsh"]
