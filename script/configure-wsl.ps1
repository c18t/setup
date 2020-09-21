Set-ExecutionPolicy Bypass -Scope Process -Force

# 管理者権限の確認
if (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) -eq $False) {
    # 管理者に昇格して再実行
    Start-Process powershell.exe -Verb runas -ArgumentList "-File ""$PSCommandPath""" -Wait
    exit $?
}

# Windows Subsystem for Linuxの確認
if ((Get-WindowsOptionalFeature -Online | Where-Object FeatureName -eq Microsoft-Windows-Subsystem-Linux).State -ne "Enabled") {
    # WSLの有効化
    Write-Host "Enable-WindowsOptionalFeature Microsoft-Windows-Subsystem-Linux ..."
    Enable-WindowsOptionalFeature -Online -NoRestart -FeatureName Microsoft-Windows-Subsystem-Linux
    if ($?) {
        Write-Host "... done!"
        exit 1
    }
    else {
        Write-Host "... failed!"
        throw "Windows Subsystem for Linuxのセットアップに失敗しました。終了します。"
    }
}

# 仮想マシンプラットフォームの確認
if ((Get-WindowsOptionalFeature -Online | Where-Object FeatureName -eq VirtualMachinePlatform).State -ne "Enabled") {
    # WSLの有効化
    Write-Host "Enable-WindowsOptionalFeature VirtualMachinePlatform ..."
    Enable-WindowsOptionalFeature -Online -NoRestart -FeatureName VirtualMachinePlatform
    if ($?) {
        Write-Host "... done!"
        exit 1
    }
    else {
        Write-Host "... failed!"
        throw "Windows Subsystem for Linuxのセットアップに失敗しました。終了します。"
    }
}

# WSLカーネルの更新
if (-Not (Get-WmiObject win32_product | Where-Object Name -eq "Windows Subsystem for Linux Update")) {
    Write-Host "install wsl2kernel update ..."

    $wslUpdateMsiUrl = "https://wslstorestorage.blob.core.windows.net/wslblob/wsl_update_x64.msi"
    $wsl2kernelPath = "$env:temp\wsl_update_x64.msi"
    Invoke-WebRequest -Uri $wslUpdateMsiUrl -OutFile $wsl2kernelPath -UseBasicParsing
    if ($? -eq $False) {
        Write-Host "... failed!"
        throw "WSL2カーネルアップデートパッケージのダウンロードに失敗しました。終了します。"
    }

    Invoke-Expression "$wsl2kernelPath /quiet /norestart"
    if ($? -eq $False) {
        Write-Host "... failed!"
        throw "WSL2カーネルのアップデートに失敗しました。終了します。"
    }

    # WSLのデフォルトバージョンを2に設定
    wsl --set-default-version 2
}

exit 0
