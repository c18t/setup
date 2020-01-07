#!/usr/bin/env bash
result=0

apt show build-essential 2>/dev/null | grep -iq '\binstalled:\s\+yes\b'
BUILD_ESSENTIAL=$?
apt show expect 2>/dev/null | grep -iq '\binstalled:\s\+yes\b'
EXPECT=$?
apt show python3-apt 2>/dev/null | grep -iq '\binstalled:\s\+yes\b'
PYTHON3_APT=$?

# install build-essential, expect, python3-apt
if [ $BUILD_ESSENTIAL -ne 0 ] || [ $EXPECT -ne 0 ] || [ $PYTHON3_APT -ne 0 ]; then
    echo install ansible dependencies ...
    sudo apt update -y \
        && sudo apt install -y build-essential expect python3-apt
    result=$?
    if [ $result -eq 0 ]; then
        echo ... done!
    else
        echo ... failed!
    fi
fi

exit $result
