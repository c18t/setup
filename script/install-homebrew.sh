#!/usr/bin/env bash
result=0

# Use FD3 to print log messages
exec 3>/dev/null
if [ -n "$VERBOSE" ]; then
    exec 3>&2
fi

echo -n "check Homebrew ..." >&3
type brew >/dev/null 2>&1
BREW=$?
([ $BREW -eq 0 ] && echo "ok." || echo "no.") >&3

# install homebrew
if [ $BREW -ne 0 ]; then
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
