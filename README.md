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
*path:* ansible/roles/homebrew/vars/
```sh
$ brew tap bundle && brew bundle dump && cat Brewfile
```

### choco.config
*path:* ansible/roles/chocolatey/vars/
```ps1
PS > (choco list --local-only) -split "[`r`n]+" | Select-String -NotMatch "packages installed" | ForEach-Object -Begin { Write-Output "---" "" "chocolatey_packages:" } -Process { Write-Output ("- { name: "+($_ -split " ")[0]+" }") }
```

### VS Code extensions
*path:* ansible/roles/vscode/vars/
```sh
$ code --list-extensions | sort | awk 'BEGIN { print "---"; print; print "code_install_extensions:" } { print "- "$1 }'
```

### fishfile
*path:* resources/fisher-my-setup/
```sh
cat ~/.config/fish/fishfile
```

## Copyrights

### ansible/roles/files/mas.sh
@yumiduka - [mas-cliをAnsibleで管理する - Qiita](https://qiita.com/yumiduka/items/9c095b9f98be96b8763c)

### その他
[LICENSE](./LICENSE)
