#!/usr/bin/env bash
pushd `dirname $0`

# install ansible
bash ./script/install-ansible-macos.sh
result=$?
if [ $result -ne 0 ]; then
    popd
    exit $result
fi

# configure with ansible
pushd ./ansible
ansible-playbook ./playbooks/iapetus-macbookpro.yml $*
result=$?
popd

if [ $result -eq 0 ]; then
    echo "$(basename $0): your machine have been configured! enjoy your development!"
fi

popd
exit $result
