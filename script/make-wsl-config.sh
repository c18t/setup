#!/usr/bin/env bash
result=0

# make wsl.conf
if ! [ -e /etc/wsl.conf ]; then
    echo '[automount]
options = "metadata"' | sudo tee /etc/wsl.conf >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        result=1
    else
        result=2
    fi
fi

exit $result
