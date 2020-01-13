#!/usr/bin/env bash
result=0

# Use FD3 to print log messages
exec 3>/dev/null
if [ -n "$VERBOSE" ]; then
    exec 3>&2
fi

echo -n "check expect ..." >&3
apt show expect 2>&3 | grep -iq '\binstalled:\s\+yes\b'
EXPECT=$?
([ $EXPECT -eq 0 ] && echo "ok." || echo "no.") >&3

echo -n "check python3-apt ..." >&3
apt show python3-apt 2>&3 | grep -iq '\binstalled:\s\+yes\b'
PYTHON3_APT=$?
([ $PYTHON3_APT -eq 0 ] && echo "ok." || echo "no.") >&3

# install expect, python3-apt
if [ $EXPECT -ne 0 ] || [ $PYTHON3_APT -ne 0 ]; then
    echo install ansible dependencies ...
    sudo apt update -y \
        && sudo apt install -y expect python3-apt
    result=$?
    if [ $result -eq 0 ]; then
        echo ... done!
    else
        echo ... failed!
    fi
fi

exit $result
