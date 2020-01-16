Dim WshShell    ' Shellオブジェクト
Dim WshEnv      ' 環境変数情報の管理オブジェクト
Dim currentPath ' 現在の環境変数PATH
Dim path        ' 環境変数PATHに追加するパス

If WScript.Arguments.Count < 2 Then
    WScript.echo("Usage: prependpath.vbs (System | User | Volatile | Process) <path>")
    WScript.Quit(-1)
End If

Set WshShell = WScript.CreateObject("WScript.Shell")
Set WshEnv = WshShell.Environment(WScript.Arguments(0))

currentPath = WshEnv.Item("PATH")
path = WScript.Arguments(1)
' WScript.echo(path <> currentPath) ' pathと環境変数PATHが一致しないこと
' WScript.echo(InStr(currentPath, path&";") = 0) ' path;が含まれないこと
' WScript.echo(InStrRev(currentPath, ";"&path)) ' 最後の;path出現位置
' WScript.echo(Len(currentPath)-Len(";"&path)+1) ' ;pathが環境変数PATHの末尾にある場合の位置
' WScript.echo(InStrRev(currentPath, ";"&path) <> (Len(currentPath)-Len(";"&path)+1)) ' 環境変数PATHの末尾が;pathでないこと
If path <> currentPath And InStr(currentPath, path&";") = 0 And InStrRev(currentPath, ";"&path) <> (Len(currentPath)-Len(";"&path)+1) Then
    ' pathが指定されていなければ先頭に追加する
    WshEnv.Item("PATH") = path & ";" & currentPath
End If
