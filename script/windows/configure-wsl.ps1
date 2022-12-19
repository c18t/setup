Set-ExecutionPolicy Bypass -Scope Process -Force
$ErrorActionPreference = "Stop"

# 管理者権限の確認
if (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) -eq $False) {
    # 管理者に昇格して再実行
    Start-Process powershell.exe -Verb runas -ArgumentList "-File ""$PSCommandPath""" -Wait
    exit $?
}

# Script設置フォルダパス
$Current = Split-Path $PSCommandPath

# Windows Subsystem for Linuxの確認
$reboot = 0
Write-Host "configure wsl ..."
$wsl = wsl --status
if (-Not $?) {
    # オプション機能の有効化、WSL2Kernelのインストール、WSLgのインストール、デフォルトディストリビューションパッケージのインストールを実行
    wsl --install
    # 再起動を要求
    $reboot = -1
}

# .wslconfigの作成
powershell -File "$Current\make-wsl-config.ps1"
$result = $LASTEXITCODE
if ($result -eq 2) {
    Write-Host "... failed!"
    throw "WSLのセットアップに失敗しました。終了します。"
}
elseif ($result -eq 1 -and $reboot -eq 0) {
    Write-Host "reboot windows subsystem for linux ..."
    # WSLの再起動
    wsl --shutdown
    Write-Host "... done!"
}
elseif ($reboot -eq -1) {
    # 再起動を要求
    Write-Host "... reboot-required!"
}
else {
    # 変更なし
    Write-Host "... done!"
}

exit $reboot
