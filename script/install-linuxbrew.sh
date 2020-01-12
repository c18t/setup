#!/usr/bin/env bash
pushd `dirname $0`
export PATH=/home/linuxbrew/.linuxbrew/bin:$PATH
result=0

# install linuxbrew dependencies
# cf. https://docs.brew.sh/Homebrew-on-Linux#linuxwsl-requirements
apt show build-essential 2>/dev/null | grep -iq '\binstalled:\s\+yes\b'
APT_BUILD_ESSENTIAL=$?
apt show file 2>/dev/null | grep -iq '\binstalled:\s\+yes\b'
APT_FILE=$?
apt show git 2>/dev/null | grep -iq '\binstalled:\s\+yes\b'
APT_GIT=$?
if [ $APT_BUILD_ESSENTIAL -ne 0 ] || [ $APT_FILE -ne 0 ] || [ $APT_GIT -ne 0 ]; then
    echo install ansible dependencies ...
    sudo apt update -y \
        && sudo apt install -y build-essential file git
    result=$?
    if [ $result -eq 0 ]; then
        echo ... done!
    else
        echo ... failed!
    fi
fi
if [ $result -ne 0 ]; then
    popd
    exit $result
fi

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
