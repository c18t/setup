#!/usr/bin/env bash

export PATH=/home/linuxbrew/.linuxbrew/bin:$PATH

# Use FD3 to print log messages
exec 3>/dev/null
if [ -n "$VERBOSE" ]; then
    exec 3>&2
fi

pushd "$(dirname "$0")" >&3 || exit $?
    # install build-essential, expect, python3-apt
    echo "call ./install-ansible-dependencies-ubuntu.sh" >&3
    ./install-ansible-dependencies-ubuntu.sh
    result=$?
    if [ $result -ne 0 ]; then
        popd >&3 || exit $?
        exit $result
    fi

    # install linuxbrew
    echo "call ./install-linuxbrew.sh" >&3
    ./install-linuxbrew.sh
    result=$?
    if [ $result -ne 0 ]; then
        popd >&3 || exit $?
        exit $result
    fi

    # install python packages
    echo "call ./install-python-packages.sh" >&3
    ./install-python-packages.sh
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
