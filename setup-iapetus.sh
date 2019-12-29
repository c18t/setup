#!/usr/bin/env bash
pushd `dirname $0`

# install ansible
./script/install-ansible-macos.sh

# configure with ansible
pushd ./ansible
ansible-playbook ./playbooks/iapetus-macbookpro.yml $*
result=$?
popd
if [ $result -eq 0 ]; then
    # read -p
    echo "$(basename $0): your machine have been configured! enjoy your development!"
fi

popd
