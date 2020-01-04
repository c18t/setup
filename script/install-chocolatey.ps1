Set-ExecutionPolicy Bypass -Scope Process -Force

# 管理者権限の確認
if (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator") -eq $False) {
    # 管理者に昇格して再実行
    Start-Process powershell.exe -Verb runas -ArgumentList "-File ""$PSCommandPath""" -Wait
    exit $?
}

# chocolateyの確認
if (-Not (Get-Command -Name choco -ErrorAction SilentlyContinue)) {
    # chocolateyのインストール
    Write-Host "install chocolatey ..."
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
    if ($? -eq $False) {
        Write-Host "... failed!"
        throw "chocolateyのインストールに失敗しました。終了します。"
    }

    Write-Host "... done!"
}

exit
