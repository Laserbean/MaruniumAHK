#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

#IfWinActive Excel

    ^BackSpace::
        Send, ^+{Left}
        Send, {BackSpace}
    Return

    ; ^XButton1::
    ;     Send, ^+{Right}
    ;     Send, {Delete}
    ; Return

    ; ^XButton2::
    ;     Send, ^+{Left}
    ;     Send, {BackSpace}
    ; Return

    +WheelDown:: ; Shift + Mouse Wheel Down
        Send {WheelRight 2} ; Scroll right twice
    Return

    +WheelUp:: ; Shift + Mouse Wheel Up
        Send {WheelLeft 2} ; Scroll left twice
    Return

    !v::
        Send, ^v

        Send, +{F10}
        Sleep, 200
        Send, {down 3}
        Sleep, 400

        Send, {Enter}

    Return

    +^s::
        Send {F12}

    Return

    ^+c::
        Clipboard := ""
        Send, ^{c}
        ClipWait, 0.25,
        if ErrorLevel
        {
            MsgBox, The attempt to copy text onto the clipboard failed.
        }

        StringReplace,Clipboard,Clipboard,`n,,A
        StringReplace,Clipboard,Clipboard,`r,,A
    Return

#IfWinActive

Clipboardbackup := ""
^+v::
    Clipboardbackup := ClipboardAll
    Clipboard := Clipboard
    Send ^v
    Sleep, 300
    Clipboard := Clipboardbackup
Return

#IfWinActive ahk_exe WINWORD.EXE
+^s::
    Send {F12}

Return
#IfWinActive
