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

```powershell
PS > .\setup-windows.ps1 setup-khronos.sh -K
```

##### Host

```
$ ./setup-khronos -e win_username=user -K -l khronos
```

##### WSL

```
$ ./setup-khronos -e win_username=user -K -l local
```

## Update config

### brewfile

```sh
$ brew tap bundle && brew bundle dump && cat Brewfile
```

### choco.config

```ps1
PS > choco list --local-only `
  | Select-String -NotMatch "packages installed" `
  | ForEach-Object `
    -Begin { Write-Output "---" "chocolatey_packages:" } `
    -Process { Write-Output ("  - { name: "+($_ -split " ")[0]+" }") }
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
  | awk 'BEGIN { print "---";  print "code_install_extensions:" }
    { print "  - "$1 }'
```

```ps1
PS > code --list-extensions `
  | ForEach-Object `
    -Begin { Write-Output "---" "code_install_extensions:" } `
    -Process { Write-Output "  - $_" }
```

### fishfile

_path:_ resources/fisher-my-setup/

```sh
cat ~/.config/fish/fishfile
```

## Copyrights

### ansible/roles/files/mas.sh

@yumiduka - [mas-cli を Ansible で管理する - Qiita](https://qiita.com/yumiduka/items/9c095b9f98be96b8763c)

### その他

[LICENSE](./LICENSE)
