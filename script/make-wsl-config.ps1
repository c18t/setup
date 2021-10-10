Set-ExecutionPolicy Bypass -Scope Process -Force
$result = 0

# make .wslconfig
$wslConfigFilePath = "$env:USERPROFILE\.wslconfig"
if (-Not (Test-Path $wslConfigFilePath)) {
    # memory: WSLのVMメモリ上限を設定する
    # swap: WSLのスワップファイルサイズを設定する
    # cf. https://docs.microsoft.com/en-us/windows/wsl/wsl-config#configure-global-options-with-wslconfig
    $content = @'
[wsl2]
memory=16G
swap=0 # for Kubernetes
'@
    # UTF-8N で書き出す
    $UTF8NoBomEnc = New-Object System.Text.UTF8Encoding $False
    [System.IO.File]::WriteAllLines($wslConfigFilePath, $content, $UTF8NoBomEnc)
    if (-Not $?) {
        $result = 2
    }
    else {
        $result = 1
    }
}

exit $result
