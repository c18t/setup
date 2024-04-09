#!/usr/bin/env bash

export PATH=/home/linuxbrew/.linuxbrew/bin:$PATH

# Use FD3 to print log messages
exec 3>/dev/null
if [ -n "$VERBOSE" ]; then
    exec 3>&2
fi

pushd "$(dirname "$0")" >&3 || exit $?
    # install ansible
    echo "call ./script/wsl/install-ansible-ubuntu.sh" >&3
    ./script/wsl/install-ansible-ubuntu.sh
    result=$?
    if [ $result -ne 0 ]; then
        popd >&3 || exit $?
        exit $result
    fi

    # configure with ansible
    pushd ./ansible >&3 || exit $?
        PLAYBOOK=./playbooks/khronos-windows.yaml
        echo "call ansible-playbook \"$PLAYBOOK\" $*" >&3
        # パーミッションの都合で読み込めないので明示的にansible.cfgを指定
        ANSIBLE_CONFIG=ansible.cfg ansible-playbook "$PLAYBOOK" "$@"
        result=$?
    popd >&3 || exit $?

    if [ $result -eq 0 ]; then
        echo "$(basename "$0"): your machine have been configured! enjoy your development!"
    fi

popd >&3 || exit $?
exit $result
