Set-ExecutionPolicy Bypass -Scope Process -Force

# 管理者権限の確認
if (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator") -eq $False) {
    # 管理者に昇格して再実行
    Start-Process powershell.exe -Verb runas -ArgumentList "-File ""$PSCommandPath""" -Wait
    exit $?
}

# ubuntuの確認
if (-Not (Get-AppPackage *CanonicalGroupLimited.Ubuntu*onWindows*)) {
    Write-Host "install ubuntu package ..."

    # ubuntuパッケージのインストール
    # cf. https://docs.microsoft.com/en-us/windows/wsl/install-manual

    $appxPath = "$env:temp\Ubuntu-1804.appx"
    Invoke-WebRequest -Uri https://aka.ms/wsl-ubuntu-1804 -OutFile $appxPath -UseBasicParsing
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
    # $ubuntuPath = (Get-Command ubuntu1804.exe | Where-Object Name -eq ubuntu1804.exe).Path
    Write-Output "Set-Alias -Name ubuntu -Value ubuntu1804.exe" | Add-Content $profile -Encoding Default
    Write-Output "Set-Alias -Name ubuntu.exe -Value ubuntu1804.exe" | Add-Content $profile -Encoding Default
    . $profile

    Write-Host "... done!"
}

# ubuntuのセットアップ
# cf. https://docs.microsoft.com/en-us/windows/wsl/user-support

# ubuntuのインストール
Write-Host "install ubuntu ..."
ubuntu.exe install
Write-Host "... done!"

# セットアップコマンドの実行
Write-Host "configure ubuntu ..."
$Current = Split-Path $PSCommandPath
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

exit
