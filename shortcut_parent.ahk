#NoEnv
#SingleInstance, Force

SendMode Input
SetWorkingDir %A_ScriptDir%

#IfWinActive ahk_class CabinetWClass
^!s:: ; Hotkey: Ctrl + Alt + S
{
    ; Get the selected folder in File Explorer
    SelectedFolder := GetSelectedFolderPath()
    if (SelectedFolder = "")
    {
        MsgBox, No folder selected. Please select a folder.
        return
    }

    ; Extract folder name and parent folder name
    FolderName := RegExReplace(SelectedFolder, "^.*\\")
    ParentFolder := RegExReplace(SelectedFolder, "\\[^\\]+$")

    ; Get parent folder name only
    ParentFolder := RegExReplace(ParentFolder, "^.*\\")
    if (ParentFolder = "")
    {
        MsgBox, Unable to determine parent folder. Aborting.
        return
    }

    ; Construct shortcut name
    ShortcutName := ParentFolder . " - " . FolderName
    ShortcutPath := SelectedFolder . "\..\ " . ShortcutName . ".lnk"

    ; Create the shortcut
    FileCreateShortcut, %SelectedFolder%, %ShortcutPath%
    ToolTip, Shortcut created: %ShortcutName%
    Sleep, 500
    ToolTip
    return
}

^!+s:: ; Hotkey: Ctrl + Alt + U
{
    ; Get the selected folder in File Explorer
    SelectedFolder := GetSelectedFolderPath()
    if (SelectedFolder = "")
    {
        MsgBox, No folder selected. Please select a folder.
        return
    }

    ; Go up 2 parent folders
    FolderName := RegExReplace(SelectedFolder, "^.*\\")
 
    ; Extract the parent folder and the current folder

    RegexPattern := "^(.*\\)?([^\\]+)\\([^\\]+)\\([^\\]+)\\?$"
    ParentFolder := RegExReplace(SelectedFolder, RegexPattern, "$2 - $3 - $4")


    if (ParentFolder = "")
    {
        MsgBox, Unable to determine parent folder. Aborting.
        return
    }
    
    ; Construct shortcut name
    ShortcutName := ParentFolder
    ; ShortcutName := ParentFolder . " - " . FolderName
    ShortcutPath := SelectedFolder . "\..\ " . ShortcutName . ".lnk"

    ; Create the shortcut
    FileCreateShortcut, %SelectedFolder%, %ShortcutPath%
    ToolTip, Shortcut created: %ShortcutName%
    Sleep, 500
    ToolTip
    return
}


GetSelectedFolderPath() {
    ; Get the selected folder path from File Explorer
    FolderPath := ""
    ClipSaved := ClipboardAll  ; Save the current clipboard content
    Clipboard := ""            ; Clear clipboard
    Send, ^c                   ; Copy selected item(s)
    ClipWait, 1                ; Wait for clipboard to contain data
    if (Clipboard != "")
        FolderPath := Clipboard
    Clipboard := ClipSaved     ; Restore clipboard content
    return FolderPath
}

#IfWinActive