#!/usr/bin/env bash
pushd `dirname $0`
export PATH=/home/linuxbrew/.linuxbrew/bin:$PATH

# install build-essential
bash ./install-build-essential-ubuntu.sh
result=$?
if [ $result -ne 0 ]; then
    popd
    exit $result
fi

# install expect
bash ./install-expect-ubuntu.sh
result=$?
if [ $result -ne 0 ]; then
    popd
    exit $result
fi

# install linuxbrew
bash ./install-linuxbrew.sh
result=$?
if [ $result -ne 0 ]; then
    popd
    exit $result
fi

# install pywinrm
bash ./install-pywinrm.sh
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
