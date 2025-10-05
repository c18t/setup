#!/usr/bin/env bash

# Use FD3 to print log messages
exec 3> /dev/null
if [ -n "$VERBOSE" ]; then
  exec 3>&2
fi

pushd "$(dirname "$0")" >&3 || exit $?
# install ansible
echo "call ./script/macos/install-ansible-macos.sh" >&3
./script/macos/install-ansible-macos.sh
result=$?
if [ $result -ne 0 ]; then
  popd >&3 || exit $?
  exit $result
fi

# configure with ansible
pushd ./ansible >&3 || exit $?
PLAYBOOK=./playbooks/iapetus-macos.yaml
echo "call ansible-playbook $PLAYBOOK $*" >&3
ANSIBLE_HOME=. ansible-playbook "$PLAYBOOK" "$@"
result=$?
popd >&3 || exit $?

if [ $result -eq 0 ]; then
  echo "$(basename "$0"): your machine have been configured! enjoy your development!"
fi

popd >&3 || exit $?
exit $result
