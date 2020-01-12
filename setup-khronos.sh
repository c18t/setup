#!/usr/bin/env bash
pushd `dirname $0`
export PATH=/home/linuxbrew/.linuxbrew/bin:$PATH

# install ansible
bash ./script/install-ansible-ubuntu.sh
result=$?
if [ $result -ne 0 ]; then
    popd
    exit $result
fi

# configure with ansible
pushd ./ansible
# パーミッションの都合で読み込めないので明示的にansible.cfgを指定
ANSIBLE_CONFIG=ansible.cfg ansible-playbook ./playbooks/khronos-windows.yml $*
result=$?
popd

if [ $result -eq 0 ]; then
    echo "$(basename $0): your machine have been configured! enjoy your development!"
fi

popd
exit $result
