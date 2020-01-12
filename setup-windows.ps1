Param($setupScript)

$setupScriptArgs = $Args

Set-ExecutionPolicy Bypass -Scope Process -Force

# 管理者権限の確認
if (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) -eq $False) {
    # 管理者に昇格して再実行
    $argList = "-File ""$PSCommandPath"" ""$setupScript"" "+($setupScriptArgs -replace "^|$", """" -join " ")
    Start-Process powershell.exe -Verb runas -ArgumentList $argList -Wait
    exit $?
}

# Script設置フォルダパス
$Current = Split-Path $PSCommandPath

# 再起動が必要
$reboot = $False

# WSLの有効化
powershell.exe -File "$Current\script\configure-wsl.ps1"
if ($? -eq $False) { exit 1 }
if ($LASTEXITCODE -eq 1) { $reboot = $True }

# Ansibleによる設定の受付準備
powershell.exe -File "$Current\script\configure-remoting-for-ansible.ps1"
if ($? -eq $False) { exit 1 }
if ($LASTEXITCODE -eq 1) { $reboot = $True }

if ($reboot) {
    $scriptName = Split-Path -Leaf $PSCommandPath
    Write-Host "Windowsの設定を変更しました。再起動後、もう一度 $scriptName を実行してください。"
}
else {
    # chocolateyのインストール
    powershell.exe -File "$Current\script\install-chocolatey.ps1"
    if ($? -eq $False) { exit 1 }

    # MSYS2/expectのインストール
    powershell.exe -File "$Current\script\install-msys2.ps1"
    if ($? -eq $False) { exit 1 }

    # ubuntuのインストール
    powershell.exe -File "$Current\script\install-wsl-ubuntu.ps1"
    if ($? -eq $False) { exit 1 }
    . $profile

    # セットアップコマンドの実行
    $driveLetter = $Current.Substring(0, 1).ToLower()
    $wslPath = "$Current\$setupScript" -replace "\\", "/" -replace "^\w:", "/mnt/$driveLetter"
    ubuntu.exe run bash "$wslPath" "-e win_username=$env:USERNAME" $setupScriptArgs
    if ($? -eq $False) { exit 1 }
}

exit 0
