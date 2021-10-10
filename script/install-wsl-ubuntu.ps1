Set-ExecutionPolicy Bypass -Scope Process -Force

# 管理者権限の確認
if (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) -eq $False) {
    # 管理者に昇格して再実行
    Start-Process powershell.exe -Verb runas -ArgumentList "-File ""$PSCommandPath""" -Wait
    exit $?
}

$Current = Split-Path $PSCommandPath

# Ubuntuパッケージの確認
if (-Not (Get-Command -Name ubuntu -ErrorAction SilentlyContinue)) {
    Write-Host "install ubuntu package ..."
    wsl --install -d Ubuntu
    Write-Host "... done!"
}

# ubuntuのセットアップ
# cf. https://docs.microsoft.com/en-us/windows/wsl/user-support

# # expectの確認
# if (-Not (Get-Command -Name expect -ErrorAction SilentlyContinue)) {
#     throw "expectが見つかりません。終了します。"
# }

# ubuntuのインストール
# $username = $env:USERNAME.ToLower() -replace "\s", ""
# $password = Read-Host "Password for new UNIX user $username to install ubuntu"
# $command = (Get-Command -Name (Get-Command -Name ubuntu).Definition).Definition
# $bytes = [System.Text.Encoding]::Unicode.GetBytes("$command install")
# $encodedCommand = [Convert]::ToBase64String($bytes)
Write-Host "install ubuntu ..."
# 権限エラー。MSYS2/expectではWindows Storeアプリは操作できないのかもしれない
# expect.exe -f "$Current\install-wsl-ubuntu.exp" "$encodedCommand" "$username" "$password"
ubuntu install
Write-Host "... done!"

# セットアップコマンドの実行
Write-Host "configure ubuntu ..."
$driveLetter = $Current.Substring(0, 1).ToLower()
$wslPath = "$Current\make-wsl-config.sh" -replace "\\", "/" -replace "^\w:", "/mnt/$driveLetter"
ubuntu run bash "$wslPath"
$result = $LASTEXITCODE
if ($result -eq 0) {
    Write-Host "... done!"
    # 変更なし
}
elseif ($result -eq 1) {
    Write-Host "reboot windows subsystem for linux ..."
    # WSLの再起動
    Stop-Service "LxssManager"
    Start-Service "LxssManager"
    Write-Host "... done!"
}
else {
    Write-Host "... failed!"
    throw "Ubuntuのセットアップに失敗しました。終了します。"
}

# ホームディレクトリの変更 (ホームディレクトリをWindows側にすると起動が凄まじく遅いのでやめる)
# $username = Read-Host "Enter new UNIX username to change home directory"
# Write-Host "change $username home directory ..."
# $driveLetter = $env:USERPROFILE.Substring(0, 1).ToLower()
# $homeDirectory = $env:USERPROFILE -replace "\\", "/" -replace "^\w:", "/mnt/$driveLetter"
# ubuntu.exe run sudo perl -pi -E "'s<:/home/${username}:><:${homeDirectory}:>g'" /etc/passwd
# $result = $LASTEXITCODE
# if ($result -ne 0) {
#     Write-Host "... failed!"
#     throw "ubuntuのセットアップに失敗しました。終了します。"
# }
# Write-Host "... done!"

exit
