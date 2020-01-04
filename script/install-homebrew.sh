#!/usr/bin/env bash
result=0

# install homebrew
if ! type brew >/dev/null 2>&1; then
    echo install homebrew ...
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    result=$?
    if [ $result -eq 0 ]; then
        echo ... done!
    else
        echo ... failed!
    fi
fi

exit $result
