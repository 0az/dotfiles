#! /bin/bash

if [ -f ~/.bash_aliases ]; then
    # shellcheck disable=SC1090
    . ~/.bash_aliases
fi

if [ -f "$XDG_CONFIG_HOME"/shell/aliases ]; then
    # shellcheck disable=SC1090
    . "$XDG_CONFIG_HOME"/shell/aliases
fi
