#!/usr/bin/env bash

# install homebrew
if ! type brew >/dev/null 2>&1; then
    echo install homebrew ...
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    echo ... done!
fi

exit 0
