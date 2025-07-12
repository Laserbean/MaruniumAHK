#NoEnv
#SingleInstance Force
#Persistent
SetWorkingDir %A_ScriptDir%

; Define your scripts here
iniFile := A_ScriptDir "\ScriptLauncher.ini"
; pids := {}
scriptDisplayNames := []  ; Parallel to `scripts`
scripts := [ "WindowResize.ahk", "WinMove.ahk", "create_text_file.ahk", "shortcut_parent.ahk", "essential.ahk", "text_replacement.ahk", "ExcelScript.ahk", "symbol_type.ahk", "CapsLockKeyNav.ahk" ]
; scripts := []
pids := {}  ; To store script name -> PID

; Create the submenu first
Menu, LaunchMenu, Add  ; Creates the empty submenu

; Set up tray menu
Menu, Tray, NoStandard
Menu, Tray, Add, Launch Script..., ShowScriptMenu
Menu, Tray, Add, Launch All Scripts..., LaunchScripts
Menu, Tray, Add, Running Scripts, ShowRunning
Menu, Tray, Add, Edit Script List..., EditScriptList
Menu, Tray, Add, Manage Scripts..., ShowScriptManager

Menu, Tray, Add, Close All, CloseAllScripts
Menu, Tray, Add, Exit Launcher, ExitAppLabel
Menu, Tray, Default, Launch Script...
Menu, Tray, Click, 1
Menu, Tray, Tip, Script Launcher

; OnExit, CloseAllScripts

LoadScripts()

return

ExitAppLabel:
    Gosub, CloseAllScripts
ExitApp
Return

ShowScriptMenu:
    Menu, LaunchMenu, DeleteAll
    for index, script in scripts
    {
        Menu, LaunchMenu, Add, %script%, LaunchScript
    }
    Menu, LaunchMenu, Show
return

LaunchScripts:
    for index, script in scripts
        LaunchScriptF(script)
Return

LaunchScript:
    script := A_ThisMenuItem
    LaunchScriptF(script)
return

LaunchScriptF(script) {
    global pids
    if (pids.HasKey(script))
    {
        MsgBox, 48, Already Running, "%script%" is already running.
        return
    }
    ; Run, %script%, , , newPID
    ; Run, %A_AhkPath% "%script%", , , newPID
    ; SplitPath, script, , , ext
    ; if (ext = "ahk")
    ;     Run, %A_AhkPath% "%script%", , , newPID
    ; else
    ;     Run, %script%, , , newPID
    SplitPath, script, , , ext
    if (ext = "ahk")
        Run, %A_AhkPath% "%script%", , Hide, newPID
    else
        Run, %script%, , Hide, newPID

    if ErrorLevel
    {
        MsgBox, 16, Error, Failed to run "%script%"
        return
    }
    pids[script] := newPID
}

ShowRunning:
    output := ""
    for script, pid in pids
    {
        if ProcessExist(pid)
            output .= script " (PID: " pid ")\n"
    }
    if (output = "")
        output := "No scripts are currently running."
    MsgBox, 64, Running Scripts, %output%
return

CloseAllScripts:
    for script, pid in pids
    {
        if ProcessExist(pid)
            Process, Close, %pid%
    }
    pids := {}  ; Clear dictionary
    MsgBox, 64, Closed, All running scripts have been closed.
return

EditScriptList:
    ; Join script paths with linebreaks for editing
    text := ""
    for i, s in scripts
        text .= s "`n"
    StringTrimRight, text, text, 1  ; Remove final newline

    InputBox, newList, Edit Script Paths, One file per line.`nThese can be .ahk or .exe paths., , 500, 400, , , , , %text%
    if (ErrorLevel)
        return  ; Cancelled

    StringSplit, lines, newList, `n
    scripts := []  ; Clear and rebuild
    Loop, %lines0%
    {
        line := Trim(lines%A_Index%)
        if (line != "")
            scripts.Push(line)
    }
    SaveScripts()
return

ShowScriptManager:
    Gui, ScriptManager:New, , Script List Manager
    Gui, ScriptManager:Add, ListBox, vScriptList w400 h200
    for i, s in scripts
        GuiControl,, ScriptList, %s%

    Gui, ScriptManager:Add, Button, gAddScript, Add
    Gui, ScriptManager:Add, Button, gRemoveScript x+10, Remove
    Gui, ScriptManager:Add, Button, gSaveScriptList x+10, Save
    Gui, ScriptManager:Add, Button, gCancelScriptManager x+10, Cancel
    Gui, ScriptManager:Show
return

AddScript:
    FileSelectFile, filePath, 3,, Select script to add, AHK Scripts (*.ahk; *.exe)
    if (filePath = "")
        return
    scripts.Push(filePath)
    SplitPath, filePath, fileName
    scriptDisplayNames.Push(fileName)
    ReloadScriptList()
return

RemoveScript:
    GuiControlGet, selected, , ScriptList
    if (selected = "")
        return
    Loop % scriptDisplayNames.Length()
    {
        if (scriptDisplayNames[A_Index] = selected) {
            scripts.RemoveAt(A_Index)
            scriptDisplayNames.RemoveAt(A_Index)
            break
        }
    }
    ReloadScriptList()
return

SaveScriptList:
    SaveScripts()
    Gui, ScriptManager:Destroy
return

CancelScriptManager:
    Gui, ScriptManager:Destroy
return

ProcessExist(PID)
{
    Process, Exist, %PID%
    return ErrorLevel
}

LoadScripts() {
    global scripts, scriptDisplayNames, iniFile
    scripts := []
    scriptDisplayNames := []

    if !FileExist(iniFile)
    {
        FileAppend,, %iniFile%
        return
    }

    index := 1
    Loop {
        IniRead, scriptPath, %iniFile%, Scripts, Script%index%,
        if (scriptPath = "")
            break
        if FileExist(scriptPath) {
            scripts.Push(scriptPath)
            SplitPath, scriptPath, fileName
            scriptDisplayNames.Push(fileName)
        }
        index++
    }
}

SaveScripts() {
    global scripts, iniFile

    ; Clear the [Scripts] section
    IniDelete, %iniFile%, Scripts

    ; Write each script path
    Loop % scripts.Length()
        IniWrite, % scripts[A_Index], %iniFile%, Scripts, Script%A_Index%
}

ReloadScriptList() {
    global scripts, scriptDisplayNames
    GuiControl,, ScriptList, |
    Loop % scriptDisplayNames.Length()
        GuiControl,, ScriptList, % scriptDisplayNames[A_Index]
}

