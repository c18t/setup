#!/usr/bin/env bash
result=0

# make wsl.conf
if ! [ -e /etc/wsl.conf ]; then
    # metadata: WSLでchmodを可能にする
    # umask: マウントした全ファイルおよびフォルダのパーミッションのマスク
    #        他のユーザーからの書き込みを制限する
    #        umask=22: 777 -> 755
    # cf. https://docs.microsoft.com/en-us/windows/wsl/wsl-config
    {
        echo '[automount]'
        echo 'options = "metadata,umask=22"'
    } | sudo tee /etc/wsl.conf >/dev/null 2>&1
    if [ $? -eq 0 ]; then
        result=1
    else
        result=2
    fi
fi

exit $result
