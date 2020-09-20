#!/usr/bin/env bash
result=0

export PATH=/home/linuxbrew/.linuxbrew/bin:$PATH

# Use FD3 to print log messages
exec 3>/dev/null
if [ -n "$VERBOSE" ]; then
    exec 3>&2
fi

pushd "$(dirname "$0")" >&3 || exit $?
    # install linuxbrew dependencies
    # cf. https://docs.brew.sh/Homebrew-on-Linux#linuxwsl-requirements

    echo -n "check build-essential ..." >&3
    apt show build-essential 2>/dev/null | grep -iq '\binstalled:\s\+yes\b'
    APT_BUILD_ESSENTIAL=$?
    ([ $APT_BUILD_ESSENTIAL -eq 0 ] && echo "ok." || echo "no.") >&3

    echo -n "check file ..." >&3
    apt show file 2>/dev/null | grep -iq '\binstalled:\s\+yes\b'
    APT_FILE=$?
    ([ $APT_FILE -eq 0 ] && echo "ok." || echo "no.") >&3

    echo -n "check git ..." >&3
    apt show git 2>/dev/null | grep -iq '\binstalled:\s\+yes\b'
    APT_GIT=$?
    ([ $APT_GIT -eq 0 ] && echo "ok." || echo "no.") >&3

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
        popd >&3 || exit $?
        exit $result
    fi

    # install linuxbrew
    if ! type brew >/dev/null 2>&1; then
        echo install linuxbrew ...
        echo -n "Password for $USER to install linuxbrew: "; IFS= read -r -s PW; echo
        expect -f ./install-linuxbrew.exp "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)" "${PW}"
        result=$?
        if [ $result -eq 0 ]; then
            echo ... done!
        else
            echo ... failed!
        fi
    fi

popd >&3 || exit $?
exit $result
