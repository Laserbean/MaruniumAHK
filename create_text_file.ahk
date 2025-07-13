; This is part of my AutoHotKey [1] script. When you are in Windows Explorer it
; allows you to press Ctrl+Alt+N and type a filename, and that file is created
; in the current directory and opened in the appropriate editor (usually
; [gVim](http://www.vim.org/) in my case, but it will use whatever program is
; associated with the file in Windows Explorer).

; This is much easier than the alternative that I have been using until now:
; Right click > New > Text file, delete default filename and extension (which
; isn't highlighted in Windows 7), type the filename, press enter twice.
; (Particularly for creating dot files like ".htaccess".)

; Credit goes to aubricus [2] who wrote most of this - I just added the
; 'IfWinActive' check and 'Run %UserInput%' at the end.

; [1]: http://www.autohotkey.com/
; [2]: https://gist.github.com/1148174

; Only run when Windows Explorer or Desktop is active
; Ctrl+Alt+N
#SingleInstance, Force

#Include, HideIcon.ahk



#IfWinActive ahk_class CabinetWClass
    ^!n::
        ; #IfWinActive ahk_class ExploreWClass
        ;     ^!n::
        ;         #IfWinActive ahk_class Progman
        ;             ^!n::
        ;                 #IfWinActive ahk_class WorkerW
        ;                     ^!n::
        ToolTip, Creating text file

        vNameNoExt := "New Text Document"
        vDotExt := ".txt"
        vPath := ""
        WinGet, hWnd, ID, A
        for oWin in ComObjCreate("Shell.Application").Windows {
            try {
                if (oWin.HWND = hWnd) {
                    vDir := oWin.Document.Folder.Self.Path
                    Loop {
                        vSfx := (A_Index=1) ? "" : " (" A_Index ")"
                        vName := vNameNoExt vSfx vDotExt
                        vPath := vDir "\" vName
                        if !FileExist(vPath)
                            ToolTip, File doesn't exist
                        break
                    }
                    FileAppend,, % vPath, UTF-8-RAW
                    ToolTip, File Append
                    break
                }
            }
            catch {

            }
        }
        oWin.Refresh()
        for Item in oWin.Document.Folder.Items
            if (Item.Path = vPath)
            oWin.Document.SelectItem(Item, 3|4|8)
        oWin := ""

        ToolTip
    return
#IfWinActive