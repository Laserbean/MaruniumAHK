#NoEnv
#SingleInstance, Force
SendMode, Input
SetBatchLines, -1
SetWorkingDir, %A_ScriptDir%

^+v::
    KeyWait, Ctrl, Up
    clipsave := ClipboardAll
    FilePath := Clipboard
    SplitPath, FilePath,, folderpath
    Clipboard = %folderpath%
    ; MsgBox, , Title, %folderpath%
    send ^{v}
    Clipboard := clipsave
return
