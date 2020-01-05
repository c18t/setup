# setup
環境のセットアップスクリプト

## How to use
### macOS
#### Iapetus
```sh
$ ./setup-iapetus.sh -K
```

### Windows
#### Khronos
```ps1
PS > .\setup-windows.ps1 setup-khronos.sh -K
```

## Update config
### brewfile
```sh
$ brew tap bundle && brew bundle dump && cat Brewfile
```

### VS Code extensions
```sh
$ code --list-extensions | sort | awk 'BEGIN { print "---"; print; print "code_install_extensions:" } { print "- "$1 }'
```

## Copyrights

### ansible/roles/files/mas.sh
@yumiduka - [mas-cliをAnsibleで管理する - Qiita](https://qiita.com/yumiduka/items/9c095b9f98be96b8763c)

### その他
[LICENSE](./LICENSE)
