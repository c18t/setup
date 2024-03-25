#!/usr/bin/env bash
result=0

# Use FD3 to print log messages
exec 3>/dev/null
if [ -n "$VERBOSE" ]; then
    exec 3>&2
fi

echo -n "check python3 ..." >&3
type pip3 >/dev/null 2>&1
PIP3=$?
([ $PIP3 -eq 0 ] && echo "ok." || echo "no.") >&3

# install python3
if [ $PIP3 -ne 0 ]; then
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
    pip3 install --break-system-package pywinrm 
    result=$?
    if [ $result -eq 0 ]; then
        echo ... done!
    else
        echo ... failed!
    fi
fi

exit $result
