#!/usr/bin/env bash
if [ "${GITHUB_ACTIONS}" == 'true' ]; then
    exit 0
fi

ANSIBLE_HOME="./ansible" ansible-lint
