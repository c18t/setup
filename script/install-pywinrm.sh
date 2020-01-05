#!/usr/bin/env bash
result=0

# install python3
if ! type pip3 >/dev/null 2>&1; then
    echo install python ...
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

# install python pacakges for ansible
if ! pip3 show pywinrm >/dev/null 2>&1; then
    echo install python pacakges for ansible ...
    pip3 install pywinrm
    result=$?
    if [ $result -eq 0 ]; then
        echo ... done!
    else
        echo ... failed!
    fi
fi

exit $result
