Set-ExecutionPolicy Bypass -Scope Process -Force

$Current = Split-Path $PSCommandPath

# Ubuntuパッケージの確認
if (-Not (Get-Command -Name ubuntu -ErrorAction SilentlyContinue)) {
  Write-Host "install ubuntu package ..."
  wsl --install -d Ubuntu
  Write-Host "... done!"
}

# ubuntuのインストール
Write-Host "install ubuntu ..."
# 権限エラー。MSYS2/expectではWindows Storeアプリは操作できないのかもしれない
# expect.exe -f "$Current\install-wsl-ubuntu.exp" "$encodedCommand" "$username" "$password"
ubuntu install
Write-Host "... done!"

# セットアップコマンドの実行
Write-Host "configure ubuntu ..."
$driveLetter = $Current.Substring(0, 1).ToLower()
$wslPath = "$Current\make-wsl-config.sh" -replace "\\", "/" -replace "^\w:", "/mnt/$driveLetter" -replace "^//wsl.localhost/Ubuntu", ""
ubuntu run bash "$wslPath"
$result = $LASTEXITCODE
if ($result -eq 0) {
  Write-Host "... done!"
  # 変更なし
}
elseif ($result -eq 1) {
  Write-Host "reboot windows subsystem for linux ..."
  # WSLの再起動
  wsl --shutdown
  Write-Host "... done!"
}
else {
  Write-Host "... failed!"
  throw "Ubuntuのセットアップに失敗しました。終了します。"
}

# ホームディレクトリの変更 (ホームディレクトリをWindows側にすると起動が凄まじく遅いのでやめる)
# ubuntu.exe run sudo perl -pi -E "'s<:/home/${username}:><:${homeDirectory}:>g'" /etc/passwd

exit
