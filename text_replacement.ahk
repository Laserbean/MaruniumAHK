#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

#Include, HideIcon.ahk


WaitForKeyRelease(keyToWaitFor) { ;from laserbeanAHK. But it's annoying to have submodules. 
    Loop {
        if (!GetKeyState(keyToWaitFor, "P")) {
            break ; Exit the loop if the specified key is not pressed
        }
        Sleep, 10 ; Sleep for 10 milliseconds to reduce CPU usage
    }
}

^+!r::
    WaitForKeyRelease("Ctrl")
    SavedClipboard := ClipboardAll
    Clipboard := "" ; Clear clipboard
    SendInput, ^c ; Copy selected text to clipboard
    ClipWait, 1 ; Wait for clipboard to contain data
    if ErrorLevel ; If no text is selected, exit
    {
        Clipboard := SavedClipboard ; Restore the clipboard contents
        return
    }
    StringGetPos, UnderscorePos, Clipboard, _ ; Check if underscore is present
    if (UnderscorePos > 0) ; If underscore is present, replace underscores with spaces
        StringReplace, Clipboard, Clipboard, _, %A_Space%, All
    else ; If no underscore is present, replace spaces with underscores
        StringReplace, Clipboard, Clipboard, %A_Space%, _, All
    SendInput, ^{v} ; Paste modified text

    Sleep, 300
    Clipboard := SavedClipboard
return

^+!t::
    WaitForKeyRelease("Ctrl")
    SavedClipboard := ClipboardAll
    Clipboard := "" ; Clear clipboard
    SendInput, ^c ; Copy selected text to clipboard
    ClipWait, 1 ; Wait for clipboard to contain data
    if ErrorLevel ; If no text is selected, exit
    {
        Clipboard := SavedClipboard ; Restore the clipboard contents
        return
    }

    StringReplace, Clipboard, Clipboard, %A_Space%, , All
    SendInput, ^{v} ; Paste modified text
    Sleep, 300
    Clipboard := SavedClipboard
Return

; +F3::
;     WaitForKeyRelease("Shift")

;     OriginalClipboard := ClipboardAll

;     Clipboard := "" ; Clear clipboard
;     Send, ^{c} ; Copy selected text
;     ClipWait, 1 ; Wait for clipboard to contain data
;     if ErrorLevel ; If no text is selected, exit
;     {
;         Clipboard := OriginalClipboard ; Restore the clipboard contents
;         return
;     }
;     ; Sleep, 300

;     ToolTip, %Clipboard%

;     StringLower, LowerText, Clipboard
;     StringUpper, UpperText, Clipboard
;     StringUpper, FirstUpperText, Clipboard, T

;     ; Cycle between lowercase, uppercase, and first letter uppercase
;     if (Clipboard == LowerText) {
;         Clipboard := UpperText
;     } else if (Clipboard == UpperText) {
;         Clipboard := FirstUpperText
;     } else {
;         Clipboard := LowerText
;     }

;     ToolTip, %Clipboard%

;     ; Sleep, 300
;     ; Paste the modified text
;     Send, ^{v}
;     ToolTip

;     ; Sleep, 300

;     LenAfter := StrLen(Clipboard)
    
;     Send, {Shift down}{Left %LenAfter%}{Shift up}

;     Clipboard := OriginalClipboard
; return


+F3::
    WaitForKeyRelease("Shift")

    OriginalClipboard := ClipboardAll

    Send, ^{c} ; Copy selected text
    ClipWait, 1 ; Wait for clipboard to contain data
    if ErrorLevel ; If no text is selected, exit
    {
        Clipboard := OriginalClipboard ; Restore the clipboard contents
        return
    }

    ; Sleep, 300

    ToolTip, %Clipboard%

    StringLower, LowerText, Clipboard
    StringUpper, UpperText, Clipboard
    StringUpper, FirstUpperText, Clipboard, T

    ; Cycle between lowercase, uppercase, and first letter uppercase
    if (Clipboard == LowerText) {
        ; Clipboard := UpperText
        Clipboard := FirstUpperText
    } else if (Clipboard == UpperText) {
        ; Clipboard := FirstUpperText
        Clipboard := LowerText
    } else {
        ; Clipboard := LowerText
        Clipboard := UpperText
    }

    ToolTip, %Clipboard%

    ; Sleep, 300
    ; Paste the modified text
    Send, ^{v}
    ToolTip

    ; Sleep, 300

    LenAfter := StrLen(Clipboard)

    ; SpaceCount := StrLen(Clipboard) - StrLen(StrReplace(Clipboard, " ", "")) + 1
    ; Send, ^+{Left %SpaceCount%}
    
    Send, {Shift down}{Left %LenAfter%}{Shift up}

    Clipboard := OriginalClipboard
return


^+!\::
    WaitForKeyRelease("Ctrl")
    SavedClipboard := ClipboardAll
    Clipboard := "" ; Clear clipboard
    SendInput, ^c ; Copy selected text to clipboard
    ClipWait, 1 ; Wait for clipboard to contain data
    if ErrorLevel ; If no text is selected, exit
    {
        Clipboard := SavedClipboard ; Restore the clipboard contents
        return
    }
    StringGetPos, UnderscorePos, Clipboard, \ ; Check if underscore is present
    if (UnderscorePos > 0) ; If underscore is present, replace underscores with spaces
        StringReplace, Clipboard, Clipboard, \, /, All
    else ; If no underscore is present, replace spaces with underscores
        StringReplace, Clipboard, Clipboard, /, \, All
    SendInput, ^{v} ; Paste modified text

    Sleep, 300
    Clipboard := SavedClipboard
return