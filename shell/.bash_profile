#! /bin/bash

echo -n '=> Executing .bash_profile... '

# echo -n 'ssh-agent... '
# eval $(ssh-agent -s -t 600) | cut -d ' ' -f 3 | xargs printf "\b\b\b\b (PID %s)... "

echo 'done.'

if [ -f ~/.profile ]; then
    # shellcheck disable=SC1090,SC1091
    . ~/.profile
fi

if [ -f "$XDG_CONFIG_HOME"/shell/profile ]; then
    # shellcheck disable=SC1090,SC1091
    . "$XDG_CONFIG_HOME"/shell/profile
fi


if [ -f ~/.config/shell/profile ]; then
    # shellcheck disable=SC1090,SC1091
    . ~/.config/shell/profile
fi

if [ -f ~/.bashrc ]; then
    # shellcheck disable=SC1090,SC1091
    . ~/.bashrc
fi
