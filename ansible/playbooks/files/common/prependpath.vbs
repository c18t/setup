Dim WshShell    ' Shell�I�u�W�F�N�g
Dim WshEnv      ' ���ϐ����̊Ǘ��I�u�W�F�N�g
Dim currentPath ' ���݂̊��ϐ�PATH
Dim path        ' ���ϐ�PATH�ɒǉ�����p�X

If WScript.Arguments.Count < 2 Then
    WScript.echo("Usage: prependpath.vbs (System | User | Volatile | Process) <path>")
    WScript.Quit(-1)
End If

Set WshShell = WScript.CreateObject("WScript.Shell")
Set WshEnv = WshShell.Environment(WScript.Arguments(0))

currentPath = WshEnv.Item("PATH")
path = WScript.Arguments(1)
' WScript.echo(path <> currentPath) ' path�Ɗ��ϐ�PATH����v���Ȃ�����
' WScript.echo(InStr(currentPath, path&";") = 0) ' path;���܂܂�Ȃ�����
' WScript.echo(InStrRev(currentPath, ";"&path)) ' �Ō��;path�o���ʒu
' WScript.echo(Len(currentPath)-Len(";"&path)+1) ' ;path�����ϐ�PATH�̖����ɂ���ꍇ�̈ʒu
' WScript.echo(InStrRev(currentPath, ";"&path) <> (Len(currentPath)-Len(";"&path)+1)) ' ���ϐ�PATH�̖�����;path�łȂ�����
If path <> currentPath And InStr(currentPath, path&";") = 0 And InStrRev(currentPath, ";"&path) <> (Len(currentPath)-Len(";"&path)+1) Then
    ' path���w�肳��Ă��Ȃ���ΐ擪�ɒǉ�����
    WshEnv.Item("PATH") = path & ";" & currentPath
End If
