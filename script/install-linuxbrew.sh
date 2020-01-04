#!/usr/bin/env bash
pushd `dirname $0`
export PATH=/home/linuxbrew/.linuxbrew/bin:$PATH
result=0

# install linuxbrew
if ! type brew >/dev/null 2>&1; then
    echo install linuxbrew ...
    echo -n "Password for $USER to install linuxbrew: "; IFS= read -s PW; echo
    expect -f ./install-linuxbrew.exp "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)" "${PW}"
    result=$?
    if [ $result -eq 0 ]; then
        echo ... done!
    else
        echo ... failed!
    fi
fi

popd
exit $result
