#!/usr/bin/env bash

# Use FD3 to print log messages
exec 3>/dev/null
if [ -n "$VERBOSE" ]; then
    exec 3>&2
fi

pushd "$(dirname "$0")" >&3 || exit $?
    # install homebrew
    echo "call ./install-homebrew.sh" >&3
    ./install-homebrew.sh
    result=$?
    if [ $result -ne 0 ]; then
        popd >&3 || exit $?
        exit $result
    fi

    echo -n "check ansible ..." >&3
    type ansible >/dev/null 2>&1
    ANSIBLE=$?
    ([ $ANSIBLE -eq 0 ] && echo "ok." || echo "no.") >&3

    # install ansible
    if [ $ANSIBLE -ne 0 ]; then
        echo install ansible ...
        brew install ansible
        result=$?
        if [ $result -eq 0 ]; then
            echo ... done!
        else
            echo ... failed!
        fi
    fi
popd >&3 || exit $?
exit $result
