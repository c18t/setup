Set-ExecutionPolicy Bypass -Scope Process -Force
$ErrorActionPreference = "Stop"

# 管理者権限の確認
if (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) -eq $False) {
    # 管理者に昇格して再実行
    Start-Process powershell.exe -Verb runas -ArgumentList "-File ""$PSCommandPath""" -Wait
    exit $?
}

# OpenSSHの確認
# cf. https://docs.ansible.com/ansible/latest/user_guide/windows_setup.html
Write-Host "configure OpenSSH ..."

# OpenSSHサーバーのセットアップ
if ((Get-WindowsCapability -Online | Where-Object Name -eq "OpenSSH.Server~~~~0.0.1.0").State -eq "NotPresent") {
    Write-Host "install OpenSSH ..."
    Add-WindowsCapability -Online -Name "OpenSSH.Server~~~~0.0.1.0"
    Write-Host "... done!"
}

if (-Not (Get-Service sshd -ErrorAction SilentlyContinue)) {
    # 再起動を要求
    Write-Host "... reboot-required!"
    exit -1
}

# sshdサービスのセットアップ
Write-Host "setup OpenSSH service ..."
if ((Get-Service | Where-Object Name -eq "ssh-agent").StartType -ne "Automatic") {
    Set-Service ssh-agent -StartupType Automatic
}
if ((Get-Service | Where-Object Name -eq "ssh-agent").Status -ne "Running") {
    Start-Service ssh-agent
}
if ((Get-Service | Where-Object Name -eq "sshd").StartType -ne "Automatic") {
    Set-Service sshd -StartupType Automatic
}
if ((Get-Service | Where-Object Name -eq "sshd").Status -ne "Running") {
    Start-Service sshd
}
Write-Host "... done!"

# OpenSSHのデフォルトシェルを設定
$existsDefaultShellSetting = Get-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -ErrorAction SilentlyContinue
$defaultShellSettingIsPowerShell = $False
if ($existsDefaultShellSetting) {
    $defaultShellSettingIsPowerShell = (Get-ItemPropertyValue -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell) -Like "*powershell*"
}
if (-Not ($existsDefaultShellSetting -And $defaultShellSettingIsPowerShell)) {
    Write-Host "set OpenSSH default shell ..."
    $shellPath = (Get-Command powershell).Source
    New-ItemProperty -Path "HKLM:\SOFTWARE\OpenSSH" -Name DefaultShell -Value $shellPath -PropertyType String -Force
    Write-Host "restart OpenSSH ..."
    Restart-Service sshd
    Write-Host "... done!"
}

# ファイアウォールの設定
if (-Not (Get-NetFirewallRule -Name sshd -ErrorAction SilentlyContinue)) {
    Write-Host "configure FirewallRule for OpenSSH Server ..."
    New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
    Write-Host "... done!"
}

exit 0

# if ([String]::IsNullOrWhiteSpace($(winrm enumerate winrm/config/Listener))) {
#     # WinRMのセットアップ
#     Write-Host "setup WinRM ..."
#     $url = "https://raw.githubusercontent.com/ansible/ansible/devel/examples/scripts/ConfigureRemotingForAnsible.ps1"
#     $file = "$env:temp\ConfigureRemotingForAnsible.ps1"
#     (New-Object -TypeName System.Net.WebClient).DownloadFile($url, $file)
#     powershell -ExecutionPolicy ByPass -File $file
#     Remove-Item $file

#     # WinRMのセットアップ完了チェック
#     if ([String]::IsNullOrWhiteSpace($(winrm enumerate winrm/config/Listener))) {
#         Write-Host "... failed!"
#         # インストールに失敗
#         throw "WinRMのセットアップに失敗しました。終了します。"
#     }
#     Write-Host "... done!"

#     $reboot = $True
# }

# # WinRMの設定
# Write-Host "configure WinRT ..."
# winrm quickconfig -force
# Set-Item -Path WSMan:\localhost\Service\Auth\Basic -Value $True
# Write-Host "... done!"

# exit $(if ($reboot) { 1 } else { 0 })

# # pythonの確認
# if ((Get-Command -Name python -ErrorAction SilentlyContinue) -eq $Null) {
#     # chocolateyでpythonのインストール
#     choco install python -y
#     refreshenv

#     # pythonのインストール完了チェック
#     if ((Get-Command -Name python -ErrorAction SilentlyContinue) -eq $Null) {
#         # pythonが見つからない
#         throw "pythonのインストールを実行しましたが、コマンドが見つかりません。再度実行してください。"
#     }
# }

# # pipのインストール(pythonと同時に入る)
# [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
# Invoke-WebRequest https://bootstrap.pypa.io/get-pip.py -OutFile $PSScriptRoot\get-pip.py
# python $PSScriptRoot\get-pip.py

# ansibleのインストール
# pip install ansible pywinrm

# ansibleの実行
# throw "ansible-playbook でエラー。fcntlがWindows環境下では使えない。Ubuntu入れてやるしかない。"
# pause
