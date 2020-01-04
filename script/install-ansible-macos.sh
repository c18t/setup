#!/usr/bin/env bash
pushd `dirname $0`

# install homebrew
./install-homebrew.sh
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
