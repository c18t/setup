#!/usr/bin/env bash
result=0

# Use FD3 to print log messages
exec 3>/dev/null
if [ -n "$VERBOSE" ]; then
    exec 3>&2
fi

echo -n "check python3 ..." >&3
brew info python | grep -q 'Not installed' >/dev/null 2>&1
NOPYTHON3=$?
([ $NOPYTHON3 -ne 0 ] && echo "ok." || echo "no.") >&3

# install python3
if [ $NOPYTHON3 -eq 0 ]; then
    echo install python3 ...
    brew install python
    result=$?
    if [ $result -eq 0 ]; then
        echo ... done!
    else
        echo ... failed!
    fi
fi
if [ $result -ne 0 ]; then
    exit $result
fi

echo -n "check pywinrm ..." >&3
pip3 show pywinrm >/dev/null 2>&1
PYWINRM=$?
([ $PYWINRM -eq 0 ] && echo "ok." || echo "no.") >&3

# install python pacakges for ansible
if [ $PYWINRM -ne 0 ]; then
    echo install python pacakges for ansible ...
    pip3 install --break-system-packages pywinrm
    result=$?
    if [ $result -eq 0 ]; then
        echo ... done!
    else
        echo ... failed!
    fi
fi

exit $result
