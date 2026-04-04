# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# the default umask is set in /etc/profile; for setting the umask
# for ssh logins, install and configure the libpam-umask package.
#umask 022

# if running bash
if [ -n "$BASH_VERSION" ]; then
    # include .bashrc if it exists
    if [ -f "$HOME/.bashrc" ]; then
	. "$HOME/.bashrc"
    fi
fi

# Shared environment for brew/pyenv/go tool paths.
if [ -f "$HOME/.config/dotfiles/shell/env.sh" ]; then
    . "$HOME/.config/dotfiles/shell/env.sh"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/bin" ] ; then
    PATH="$HOME/bin:$PATH"
fi

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

export GOPATH=/home/crash/go
export GOROOT=/usr/local/go
export PATH=$GOPATH/bin:$PATH
export PATH=$GOROOT/bin:$PATH
export PATH="$HOME/.local/bin/node-v16.13.1-linux-x64/bin":$PATH
. "$HOME/.cargo/env"
