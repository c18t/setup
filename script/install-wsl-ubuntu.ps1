Set-ExecutionPolicy Bypass -Scope Process -Force

# 管理者権限の確認
if (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) -eq $False) {
    # 管理者に昇格して再実行
    Start-Process powershell.exe -Verb runas -ArgumentList "-File ""$PSCommandPath""" -Wait
    exit $?
}

$Current = Split-Path $PSCommandPath

# ubuntuの確認
if (-Not (Get-AppPackage *CanonicalGroupLimited.Ubuntu*onWindows*)) {
    Write-Host "install ubuntu package ..."

    # ubuntuパッケージのインストール
    # cf. https://docs.microsoft.com/en-us/windows/wsl/install-manual

    $appxPath = "$env:temp\Ubuntu-2004.appx"
    Invoke-WebRequest -Uri https://aka.ms/wslubuntu2004 -OutFile $appxPath -UseBasicParsing
    if ($? -eq $False) {
        Write-Host "... failed!"
        throw "ubuntuパッケージのダウンロードに失敗しました。終了します。"
    }

    Add-AppxPackage $appxPath
    if ($? -eq $False) {
        Write-Host "... failed!"
        throw "ubuntuのインストールに失敗しました。終了します。"
    }

    Remove-Item $appxPath

    Write-Host "... done!"
}

if (-Not (Get-Command -Name ubuntu -ErrorAction SilentlyContinue)) {
    Write-Host "add alias for ubuntu ..."

    # ubuntu.exe のエイリアスを作成
    # $ubuntuPath = (Get-Command ubuntu2004.exe | Where-Object Name -eq ubuntu2004.exe).Path
    Write-Output "Set-Alias -Name ubuntu -Value ubuntu2004.exe" | Add-Content $profile -Encoding Default
    Write-Output "Set-Alias -Name ubuntu.exe -Value ubuntu2004.exe" | Add-Content $profile -Encoding Default
    . $profile

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
ubuntu.exe install
Write-Host "... done!"

# セットアップコマンドの実行
Write-Host "configure ubuntu ..."
$driveLetter = $Current.Substring(0, 1).ToLower()
$wslPath = "$Current\make-wsl-config.sh" -replace "\\", "/" -replace "^\w:", "/mnt/$driveLetter"
ubuntu.exe run bash "$wslPath"
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
    throw "ubuntuのセットアップに失敗しました。終了します。"
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
