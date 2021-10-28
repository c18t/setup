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
PS > Set-ExecutionPolicy RemoteSigned
PS > .\setup-windows.ps1 setup-khronos.sh -K
```

##### Host

```sh
$ ./setup-khronos.sh -e win_username=user -K -l khronos
```

##### WSL

```sh
$ ./setup-khronos.sh -e win_username=user -K -l local
```

## Update config

### brewfile

```sh
$ brew tap bundle && brew bundle dump && cat Brewfile
```

### scoop export

```ps1
PS > scoop export `
  | ForEach-Object `
    -Begin { Write-Output "---" "scoop_packages:" } `
    -Process { $local:g = ""; `
      if ($_ -match "\*global\*") { $g = ", global: true"; } `
      Write-Output ("  - { name: "+($_ -split " ")[0]+$g+" }") `
    }
```

### VS Code extensions

```sh
$ code --list-extensions \
  | awk 'BEGIN { print "---"; print "vscode_extensions:" }
    { print "  - "$1 }'
```

```ps1
PS > code --list-extensions `
  | ForEach-Object `
    -Begin { Write-Output "---" "vscode_extensions:" } `
    -Process { Write-Output "  - $_" }
```

### fishfile

_path:_ ansible/playbooks/files/fisher-my-setup/

```sh
cat ~/.config/fish/fishfile
```

## Copyrights

### ansible/roles/files/mas.sh

@yumiduka - [mas-cli を Ansible で管理する - Qiita](https://qiita.com/yumiduka/items/9c095b9f98be96b8763c)

### その他

[LICENSE](./LICENSE)
