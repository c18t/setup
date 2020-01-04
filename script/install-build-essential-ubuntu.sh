#!/usr/bin/env bash
result=0

# install build-essential
if ! apt show build-essential 2>/dev/null | grep -iq '\binstalled:\s\+yes\b'; then
    echo install build-essential ...
    sudo apt update -y \
        && sudo apt install -y build-essential
    result=$?
    if [ $result -eq 0 ]; then
        echo ... done!
    else
        echo ... failed!
    fi
fi

exit $result
