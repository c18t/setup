# setup

[![setup](https://github.com/c18t/setup/actions/workflows/setup.yaml/badge.svg)](https://github.com/c18t/setup/actions/workflows/setup.yaml)
[![pre-commit](https://github.com/c18t/setup/actions/workflows/pre-commit.yaml/badge.svg)](https://github.com/c18t/setup/actions/workflows/pre-commit.yaml)

環境のセットアップスクリプト

## How to use

### macOS

#### Iapetus

```sh
./setup-iapetus.sh -K
```

### Windows

#### Khronos

```ps1
PS > Set-ExecutionPolicy RemoteSigned
PS > .\setup-windows.ps1 setup-khronos.sh -K
```

##### Host

```sh
./setup-khronos.sh -e win_username=user -K -l khronos
```

##### WSL

```sh
./setup-khronos.sh -e win_username=user -K -l local
```

## Update config

### setup project

```sh
mise run setup
```

### fishfile

_path:_ ansible/playbooks/files/fisher-my-setup/

```sh
cat ~/.config/fish/fish_plugins
```

### brewfile

_path (for macOS):_ ansible/playbooks/files/homebrew/Brewfile-mac

_path (for WSL):_ ansible/playbooks/files/homebrew/Brewfile-wsl

```sh
brew bundle dump --describe
```

### VS Code extensions

```sh
code --list-extensions | awk '{ print "vscode \""$1"\"" }'
```

```ps1
PS > code --list-extensions `
  | ForEach-Object -Process { Write-Output "vscode ""$_""" }
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

### Visual Studio

_path:_ ansible/playbooks/files/visual-studio/.vsconfig

```ps1
PS > & "C:\\Program Files (x86)\\Microsoft Visual Studio\\Installer\\setup.exe" export -p --channelId VisualStudio.17.Preview --productId Microsoft.VisualStudio.Product.Community --config .vsconfig
```

## Copyrights

[LICENSE](./LICENSE)
