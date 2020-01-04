#!/usr/bin/env bash
result=0

# install expect
if ! apt show expect 2>/dev/null | grep -iq '\binstalled:\s\+yes\b'; then
    echo install expect ...
    sudo apt update -y \
        && sudo apt install -y expect
    result=$?
    if [ $result -eq 0 ]; then
        echo ... done!
    else
        echo ... failed!
    fi
fi

exit $result
