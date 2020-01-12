#!/usr/bin/env bash
pushd `dirname $0`
export PATH=/home/linuxbrew/.linuxbrew/bin:$PATH

# install build-essential, expect, python3-apt
./install-ansible-dependencies-ubuntu.sh
result=$?
if [ $result -ne 0 ]; then
    popd
    exit $result
fi

# install linuxbrew
./install-linuxbrew.sh
result=$?
if [ $result -ne 0 ]; then
    popd
    exit $result
fi

# install python packages
./install-python-packages.sh
result=$?
if [ $result -ne 0 ]; then
    popd
    exit $result
fi

# install ansible
if ! type ansible >/dev/null 2>&1; then
    echo install ansible ...
    brew install ansible
    result=$?
    if [ $result -eq 0 ]; then
        echo ... done!
    else
        echo ... failed!
    fi
fi

popd
exit $result
