Set-ExecutionPolicy Bypass -Scope Process -Force

# 管理者権限の確認
if (([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) -eq $False) {
    # 管理者に昇格して再実行
    Start-Process powershell.exe -Verb runas -ArgumentList "-File ""$PSCommandPath""" -Wait
    exit $?
}

# chocomateyの確認
if (-Not (Get-Command -Name choco -ErrorAction SilentlyContinue)) {
    throw "chocolateyが見つかりません。終了します。"
}

# MSYS2の確認
if (-Not (Get-Command -Name pacman -ErrorAction SilentlyContinue)) {
    Write-Host "install msys2 ..."

    # MSYS2のインストール
    choco install -y msys2
    if ($? -eq $False) {
        Write-Host "... failed!"
        throw "MSYS2のインストールに失敗しました。終了します。"
    }

    # MSYS2用環境変数
    ## NOTE: MSYS's ln command cannot make symlink
    ##       if you want to make symlink by 'ln', 
    ##       you should set environment variable MSYS=winsymlinks:nativestrict
    [System.Environment]::SetEnvironmentVariable("MSYS", "winsymlinks:nativestrict", [System.EnvironmentVariableTarget]::User)
    [System.Environment]::SetEnvironmentVariable("MSYS2_PATH_TYPE", "inherit", [System.EnvironmentVariableTarget]::User)

    # MSYS2の/usr/binにパスを通す
    $Current = Split-Path $PSCommandPath
    cscript.exe "//nologo" "$Current\addpath.vbs" "System" "$env:SYSTEMDRIVE\tools\msys64\usr\bin"
    RefreshEnv.cmd

    Write-Host "... done!"
}

# expectの確認
if (-Not (Get-Command -Name expect -ErrorAction SilentlyContinue)) {
    Write-Host "install msys2/expect ..."

    # expectのインストール
    pacman.exe -S --noconfirm expect
    if ($? -eq $False) {
        Write-Host "... failed!"
        throw "MSYS2/expectのインストールに失敗しました。終了します。"
    }

    Write-Host "... done!"
}

exit
