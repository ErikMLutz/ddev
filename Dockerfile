FROM python:3.8

# create storage directory for DDev resources
RUN mkdir /ddev

# Add DebianUnstable to APT sources
RUN echo "deb http://http.us.debian.org/debian unstable main non-free contrib" >> /etc/apt/sources.list
RUN echo "deb-src http://http.us.debian.org/debian unstable main non-free contrib" >> /etc/apt/sources.list
RUN bash -c 'echo -e "Package: *\nPin: release a=stable\nPin-Priority: 700\n" >> /etc/apt/preferences'
RUN bash -c 'echo -e "Package: *\nPin: release a=unstable\nPin-Priority: 600\n" >> /etc/apt/preferences'

# Install Packages
RUN apt update
RUN apt --yes install \
    man \
    util-linux \
    bash \
    zsh \
    zsh-autosuggestions \
    zsh-syntax-highlighting\
    curl \
    git \
    subversion \
    neovim \
    perl \
    file \
    docker.io \
    ripgrep \
    direnv \
    fd-find \
    tree

# Install Packages from DebianUnstable
RUN apt --yes -t unstable install \
    tmux \
    bat \
    less

# Rename several installed commands to their more standard forms
RUN ln -s /usr/bin/batcat /usr/bin/bat
RUN ln -s /usr/bin/fdfind /usr/bin/fd

# Install Oh-My-Zsh
ENV ZSH=/usr/share/oh-my-zsh
ENV ZSH_CUSTOM=$ZSH/custom
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install Powerlevel10k
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k

# Install Z
RUN curl --create-dirs -o /usr/share/z/z.sh https://raw.githubusercontent.com/rupa/z/master/z.sh

# Install git-flow
RUN sh -c "$(curl -fsSL https://raw.github.com/nvie/gitflow/develop/contrib/gitflow-installer.sh)"

# Install FZF
RUN git clone --depth 1 https://github.com/junegunn/fzf.git /ddev/fzf
RUN /ddev/fzf/install --bin
RUN cp /ddev/fzf/bin/* /usr/bin/

# clone themes from Chris Kempson's Base-16 repository
RUN svn export https://github.com/chriskempson/base16-shell/trunk/scripts /ddev/themes
COPY .ddev/misc/convert_theme_file.sh /bin/convert_theme_file.sh
RUN chmod +x /bin/convert_theme_file.sh
RUN for theme in /ddev/themes/*; do convert_theme_file.sh $theme; done
RUN rm /ddev/themes/base16-*

# Install terminfo configuration
COPY .ddev/misc/xterm-24bit.terminfo /ddev/xterm-24bit.terminfo
RUN tic -x /ddev/xterm-24bit.terminfo
ENV TERM=xterm-24bit

# Install Python packages
RUN pip3 install \
    neovim \
    docker-compose

# add scripts to bin
COPY .ddev/misc/entrypoint.zsh /bin/entrypoint.zsh
RUN chmod +x /bin/entrypoint.zsh
COPY .ddev/misc/link_dotfiles.zsh /bin/link_dotfiles.zsh
RUN chmod +x /bin/link_dotfiles.zsh

# set locale so that tmux opens using proper font
ENV LANG=en_US.UTF-8

ENTRYPOINT ["entrypoint.zsh"]
