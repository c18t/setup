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
    Write-Host "Enable-WindowsOptionalFeature ..."
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

exit 0
