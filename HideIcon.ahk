; #NoEnv
; #SingleInstance, Force
; SendMode, Input
; SetBatchLines, -1
; SetWorkingDir, %A_ScriptDir%

; param := %1%

; ToolTip, %param%

; sleep, 1000
; ToolTip

for n, param in A_Args  ; For each parameter:
{
    ; MsgBox Parameter number %n% is %param%.
    if (param = "noIcon"){
        Menu, Tray, NoIcon
    }
}