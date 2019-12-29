#!/usr/bin/env bash
pushd `dirname $0`

# install homebrew
./install-homebrew.sh

# install ansible
if ! type ansible >/dev/null 2>&1; then
    echo install ansible ...
    brew install ansible
    echo ... done!
fi

popd
exit 0
