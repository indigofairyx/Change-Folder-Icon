; -[--- Start of X:\AHK\xINC\ChangeFolderIcon\ChangeFolderIcon.ahk ---]-

;@Ahk2Exe-SetProductName Change Folder Icon
;@Ahk2Exe-SetDescription Change Folder Icons from a Quick and Simple GUI
;@Ahk2Exe-SetInternalName Change Folder Icon
;@Ahk2Exe-SetMainIcon icons\ChangeFolderIcon.ico

global ImportantEncodingMSG := "!IMPORTANT! - **THIS FILE MUST BE ENCODED WITH UTF8+BOM** !"

;; #ToDo 10-27-2025 --> add icons to whole tree unless there is already a desktop.ini in the if folder, eg ... If !FileExist(desktopini) { create dtini } else { return } ... batch deleting could be messed up by this sooo.... ;; at folder info top to d.ini, with a label? to batch delete infoip must match tag# in dope this shows up as a comment: . and its not seen in EV tooltip
    
;; 10-29-2025 have .ico sent as parma load into ico field?
;; - [x] look for .exe relative\one level below and load them as an ico option. read .exe icons

;; - [x] make gui resize and have edits 1 & 2 Resize with it. and other edit too ++
; - [x] FIX FONT size on buttons for custom fonts 03-14-2026

;; 11-07-2025  have folder.ico save a log of changes= ++,path\d.ini,icon | --,path\d.ini

    
;===========================================================================
;===========================================================================
;===========================================================================



; -[--- Start of X:\AHK\xINC\x[env].ahk ---]-




Envget, atemp, atemp
Envget, ahk, ahk
Envget, xinc, xinc
Envget, XScript, XScript

envget, userprofile, userprofile
EnvGet, LocalAppData, LocalAppData
envget, appdata, appdata
global ahk, xinc, atemp, userprofile, LocalAppData, appdata, path, XScript
global mainscript := ahk "\xxx.ahk"

SetWorkingDir,%A_ScriptDir%
splitpath, A_ScriptFullPath, , , A_ScriptEXT, A_ScriptStem
global SourceScript := A_ScriptDir "\" A_ScriptStem ".ahk"
splitpath, SourceScript, source_name,,source_ext,source_stem
global CompiledScript := A_ScriptDir "\" A_ScriptStem ".exe"
splitpath, CompiledScript, compiled_name,,,compiled_stem
global compiled_name


global fileversion
filegetversion, fileversion, %a_scriptfullpath%
#SingleInstance Force
#Persistent
; #Requires Autohotkey v1.1.33+
#Requires Autohotkey v1.1.+

CoordMode, tooltip, mouse

; SetWorkingDir,%A_scriptdir%
; SplitPath, A_scriptfullpath, a_name,a_dir,a_ext,a_stem

global inifile := A_scriptdir "\ChangeFolderIcon.ini" 
if !FileExist(inifile)
{
    Tip("Making a new settings file.", 3000)
    ; iniwrite, 1, %inifile%, 1, 1
    sleep 500
    gosub makeini
    sleep 1000
    ; IniDelete, %inifile%, 1

}
global changelog := A_scriptdir "\ChangeFolderIcon - ChangeLog.txt"
if !Fileexist(changelog)
	gosub Makechangelog
global icons := A_ScriptDir "\Icons"
If (A_AhkPath ~= "i)AutoHotkeyU.*_UIA\.exe$") ; Running UIA
    Global A_IsUIA := 1
    
global AutoClearTooltips := 1
global ClearToolTipTimer := 5000

inireadsection("Settings")
INIReadSection("Programs")
global IS := MenuIconSize

if (StartAsAdmin)
	gosub RunAsAdmin

global A_Enter := "`r`n"
global A_Return := "`r`n"
global A_R := "`r`n"
global A_NewLine := "`n"
global A_NL := "`n"
global A_Quote := """"
global A_Q := """"

If FileExist(xINC "\OneCMD\CompileX.exe")
    global CompileX := xINC "\OneCMD\CompileX.exe"
;===========================================================================
;===========================================================================
;===========================================================================

    ; global iniSide_config := "Config_" A_ScriptStem
    ; iniread, INISectionList, %inifile%
    ; if instr(inisectionlist, iniSide_config)
        ; box(iniside_config " is seen in inifile`n`nsections=`n" inisectionlist)
    ; myinisections := {}
    ; loop, parse, INISectionList,
        ; for _, v in INISectionList
            ; myinisections .= 
    ; box(inisectionlist)

;===========================================================================
;===========================================================================
;===========================================================================


; -[--- Start of X:\AHK\xINC\FUNCs\Func(Clipboard).ahk ---]-
;///////////////////////// CLIPBOARD FUNCTION ;/////////////////////////

;; from fastkeys
; Paste from Clipboard•^{vk56}•••
; Copy to Clipboard•^{vk43}•••
; Cut to Clipboard•^{vk58}•••


;------------------------- CAPS KEY FUCNCTIONS--------CAPSLOCK-------------------------------------
;; start the paste of eclm
IfLive() ;; function ;; checks if Auto Copy is running
{
	global ClipSaved
    global AutoCopyWhenOpeningCMenu
	global ForceLiveMenu
	; Global filename, dir, ext, filestem, drive
    if (AutoCopyWhenOpeningCMenu || ForceLiveMenu) ;; #todo, update this in SHARE
    {
        ; do nothing continue with the Auto Copied clipboard data
		; msgbox Your menu is live!`nThe clipboard will be used for the next menu item that requires text. (without send ^c again)`n`nclipboard:  %clipboard%
    }
    else ; if not live
    {
        CopyClipboardCLM()  ; Copy before continuing
    }
}

CopyClipboardCLM() ;; Function
{
global ClipSaved  ;Ensure global is used if ClipSaved is accessed elsewhere
Global filename, dir, ext, filestem, drive, lastfolder, highlighted ;, selected
global ClipSaved := ""
; Global ClipFail := 0
ClipSaved := ClipboardAll  ; Save the current clipboard contents
sleep getdelaytime() * 1000
; sleep 50
; sleep 369 ; todo broken fix adjust time longer if needed
Clipboard := ""  ; Clear the clipboard
Sleep 30  ; Adjust the sleep time if needed
; WinGet, id, ID, A
; WinGetClass, class, ahk_id %id%
; if (class ~= "(Cabinet|Explore)WClass|Progman|dopus.lister")
	; Send {F2}
Sendinput ^{vk43} ; Sendinput  ^c ; Sendinput ^{vk43}  ; Send Ctrl+C COPY
ClipWait, 1
  ; Check if clipboard is empty, a tab, or just whitespace
if (ErrorLevel || Clipboard = "" || Clipboard = A_Tab || RegExMatch(Clipboard, "^\s+$")) ; if ErrorLevel
	{
		Tooltip, Copy Failed!`nOr you did not have text selected.`nYour Previous Clipboard Content is Restored. ;, 2, 18
		SetTimer, RemoveToolTip, -1500
		Clipboard := ClipSaved  ; Restore the clipboard
        sleep getdelaytime() * 1000 ;; removed it it add more delay
		ClipSaved := ""  ; clear the variable
		sleep 20
		return errorlevel
	}
}

PasteClipboardCLM() ;; function
{
global ClipSaved
sleep 20
		; WinGet, id, ID, A  ; Get the ID of the active window ; errorlevel checks
		; WinActivate, ahk_id %id%  ; Activate the window
		; sleep 300
; WinGet, id, ID, A
; WinGetClass, class, ahk_id %id%
; if (class ~= "(Cabinet|Explore)WClass|Progman|dopus.lister")
	; Send {F2}
send, ^v ; Sendinput, ^{vk43} ; send, ^v, ; Sendinput, ^{vk43} ; Sendinput, ^v  ; Send Paste
sleep getdelaytime() * 1000
sleep 200
; Sleep 500  ; Give the system time to paste the clipboard content
Clipboard := ClipSaved  ; {Restore the saved clipboard contents}
sleep 200 ; 300 ; old 10-08-2025 
ClipSaved := ""  ; Clear the variable
; sleep 20
}

RestoreClipboard() ;; function
{
global Clipsaved
clipboard := ""
sleep 30
Clipboard := ClipSaved
sleep getdelaytime() * 1000
; sleep 1000
sleep 100
ClipSaved := ""  ; Clear the variable
; sleep 50
}

BackupClipboard() ;; Function
{
Global ClipSaved
Clipsaved := "" ; clear the last ClipSaved
sleep 20
ClipSaved := ClipboardAll ; save the current clipboard to memory
sleep 200 ; 400 ; old changed 10-08-2025
Clipboard := "" ; empty the clipboard, ready to revive content
sleep 20
}

pasteasplaintext() ;; function
{
global ClipSaved
ClipSaved := ClipboardAll  ; save original clipboard contents
sleep 300
Clipboard := Clipboard  ; remove formatting
sleep 100
WaitForNpp()
Send ^v  ; send the Ctrl+V command
Sleep 200  ; give some time to finish paste (before restoring clipboard)
Clipboard := ClipSaved  ; restore the original clipboard contents
sleep 300
ClipSaved := ""  ; clear the variable
}

basiccopy() ;; function
{
Global ClipSaved
SendInput, ^c ;Send ^{vk43} ;Ctrl C ;  Send {Ctrl down}c{Ctrl up}  ; Send ^{vk43} ; Send ^c
; return
}

basiccut() ;; Function
{
Global ClipSaved
SendInput, ^x
; return
}

basicpaste() ;; Function
{
Global ClipSaved
WaitForNpp()
Send ^{vk56} ;Ctrl V ; SendInput, ^v, send, ^v ; Send {Ctrl down}v{Ctrl up}
sleep 200
; return
}
clearclip()
{
    clipboard := ""
    sleep 40
; clearclip: ;; old
	; run, cmd /C "echo off | clip"
; return
}
TipClip(tout:="")
{
    if (Tout = "")
        Tout := 2500
    clipwait,0.5
    if (clipboard != "")
    {
        tooltip Copied... `n%clipboard%
        SetTimer, RemoveToolTip, -%tout%
    }
}
ClipTip(tout:="")
{
    if (Tout = "")
        Tout := 2500
    clipwait,0.5
    if (clipboard != "")
    {
        tooltip Copied... `n%clipboard%
        SetTimer, RemoveToolTip, -%tout%
    }
}
basicSelectAll() ;; function
{
; sendinput, {blind}{Control down}{a}{control up} ; send ^a

}

getfileinfo() ;; function
{
    Global ClipSaved, filename, dir, ext, filestem, drive, A_File, lastfolder, highlighted
    iflive()
    sleep 100
    cleanupPATHstring()
    sleep 100
    ; SplitPath, Clipboard, filename, dir, ext, filestem, drive
}



;; call cleanupPATHstring usage
; old way - cleans whatever is in clipboard
; cleanupPATHstring()

; new way - get selected text first, then clean it
; GetText(sel)
; cleanupPATHstring(sel)

; or one liner
; cleanupPATHstring(GetText())



cleanupPATHstring(input := "") ;; function
{
;; new function from claude 01-31-2025, 5th fix for windows enviVars, seems likes its fixed, old fucntion is OKTD
Global ClipSaved, filename, dir, ext, filestem, drive, lastfolder, A_File, highlighted, match, match1, icons,
; Basic cleanup
    ; use passed input or fall back to clipboard ; ai added 04-04-2026
    if (input != "")
        Clipboard := input
        
Clipboard := RegExReplace(RegExReplace(Clipboard, "\r?\n"," "), "(^\s+|\s+$)")  ; remove line breaks\returns
Clipboard := RegExReplace(Clipboard, "^(?:'*)|('*$)")  ; remove single quotes
Clipboard := StrReplace(clipboard,"""")  ; remove double quotes
Clipboard := RegExReplace(Clipboard, ",\s*$")  ; Remove trailing comma and spaces

    If (SubStr(Clipboard, 1, 8) = "file:///")
	{ ; Handle file:/// URLs
        decodeURLpath(clipboard)
        goto splitcleaned_int
    }
    If InStr(Clipboard, "%A_ScriptDir%")
	{ ; Handle AHK variables
        clipboard := StrReplace(Clipboard, "%A_ScriptDir%", A_ScriptDir)
        dir := RegexReplace(clipboard, "\\[^\\]*$", "")
    } ;[; Cut to Clipboard•^{vk58}•••][}[; Cut to Clipboard•^{vk58}•••]]
	If InStr(clipboard, "%icons%")
	{ ; Handle x AHKs x variable
		clipboard := StrReplace(clipboard, "%icons%", A_ScriptDir "\Icons")
		dir := RegexReplace(clipboard, "\\[^\\]*$", "")
	}
    Loop
	{ ; Handle environment variables
        ; Match any %variable% pattern
        if RegExMatch(Clipboard, "i)%(\w+)%", match) {  ;; %ahk%\xxx.ahk ;testing-debug
            ; Get the environment variable value
            EnvGet, envValue, %match1%
            if (envValue != "") {
                ; Replace the %variable% with its value
                Clipboard := StrReplace(Clipboard, match, envValue)
                continue
            } else {
                tooltip, ERR! @Line#:  %A_linenumber%`nEnvironment variable %match1% not found
                SetTimer, RemoveToolTip, -1500
                break
            }
        }
        break
    }

splitcleaned_int:
    SplitPath, Clipboard, filename, dir, ext, stem, drive
    lastfolder := dir
    lastfolder := RegExReplace(lastfolder, ".*\\([^\\]+)\\?$", "$1")
    ; sleep 10
    ; return
}




decodeURLpath(IPath) {
    workingPath := IPath
    if (SubStr(workingPath, 1, 8) = "file:///")
        workingPath := SubStr(workingPath, 9)
    
    doc := ComObjCreate("HTMLfile")
    doc.write("<script>function decode(s){return decodeURIComponent(s);}</script>")
    doc.close()
    workingPath := doc.Script.decode(StrReplace(workingPath, "\", "/"))
    workingPath := StrReplace(workingPath, "/", "\")
    return workingPath
}

;;;;;;;;;;; If that also errors, fall back to the 32-bit ScriptControl method but wrapped in a try:
; decodeURLpath(IPath) {
    ; workingPath := IPath
    ; if (SubStr(workingPath, 1, 8) = "file:///")
        ; workingPath := SubStr(workingPath, 9)
    
    ; try {
        ; sc := ComObjCreate("ScriptControl")
        ; sc.Language := "JScript"
        ; workingPath := sc.Eval("decodeURIComponent('" StrReplace(workingPath, "'", "\'") "')")
    ; }
    ; workingPath := StrReplace(workingPath, "/", "\")
    ; return workingPath
; }




global MyText
; Copies the selected text to a variable while preserving the clipboard. ; Handy function.
GetText(ByRef MyText = "")
{
    SavedClip := ClipboardAll
    Clipboard =
    Send ^{vk43} ;Send, ^c ;Ctrl C
    ClipWait 0.5
    If ERRORLEVEL
    {
        Clipboard := SavedClip
        MyText =
        tip("Err! Getting text with " A_ThisFunc "()", 1500)
        Return
    }
    MyText := Trim(Clipboard)
    Clipboard := SavedClip
    Return MyText
}

; Pastes text from a variable while preserving the clipboard.
PutText(MyText)
{
   SavedClip := ClipboardAll 
   Clipboard =              ; For better compatability
   Sleep 20                 ; with Clipboard History
   Clipboard := MyText
   Send ^v
   Sleep 300
   Clipboard := SavedClip
   Return
}


;--------------------------------------------------


;This makes sure sure the same window stays active after showing the InputBox.
;Otherwise you might get the text pasted into another window unexpectedly.
SafeInput(Title, Prompt, Default = "")
{
   ActiveWin := WinExist("A")
   InputBox OutPut, %Title%, %Prompt%,,, 120,,,,, %Default%
   WinActivate ahk_id %ActiveWin%
   Return OutPut
}



;///////////////////////////////////////////////////////////////////////////
;; get delay time fuction for dynamic sleeps
;; xnote todo, this I also being used in x ahks x capslock menu.ahk, .... this should be in SHARED FUCN??
; viewdelaytime:
; getdelaytime()
; msgbox Delay_Time: %delay_time%`ndelaytick: %delaytick% ;`n freq: %freq%
; return
;-------------------------
/*
;;; raw code from forum, below is edit by AUTOHOTKEY Gurus
; delaytime()
; {
; global
; DllCall("QueryPerformanceFrequency", "Int64*", freq)
; DllCall("QueryPerformanceCounter", "Int64*", CounterBefore)
; Sleep 1000
; DllCall("QueryPerformanceCounter", "Int64*", CounterAfter)
; MsgBox % "Elapsed QPC time is " . (CounterAfter - CounterBefore) / freq * 1000 " ms"
; }
*/

/*
DynamicSleep(*)
{
	; Get the frequency of the high-resolution performance counter
	DllCall("QueryPerformanceFrequency", "Int64*", &freq := 0)

	; Get the current value of the high-resolution performance counter
	DllCall("QueryPerformanceCounter", "Int64*", &CounterBefore := 0)

	; Loop 10,000,000 times (this seems to be a placeholder for some work)
	loop 10000000
		num := A_Index  ; A_Index is the current loop iteration number

	; Get the current value of the high-resolution performance counter again
	DllCall("QueryPerformanceCounter", "Int64*", &CounterAfter := 0)

	; Calculate the elapsed time in milliseconds
	delay_time := (CounterAfter - CounterBefore) / freq * 1000

	; Sleep for the calculated delay time
	Sleep Round(delay_time)
} 

*/
GetDelayTime() ;; function
{
	listlines, off
;; Demonstrates QueryPerformanceCounter(), which gives more precision than A_TickCount's 10 ms., source: https://www.autohotkey.com/docs/v1/lib/DllCall.htm
;; video ref: https://www.youtube.com/watch?v=TKxiqnZLcz8 , title: How to Creating a self-Adjusting Sleep that adjusts to your Computer's Load
;; !!!! usage example = sleep getdelaytime() * 1000 ;; the * 1000 matches the bottomline of the fucntion both can be delected
	global delay_time, delaytick
	DllCall("QueryPerformanceFrequency", "Int64*", freq := 0)
	DllCall("QueryPerformanceCounter", "Int64*", CounterBefore := 0)
	loop 1000
		delaytick := A_Index
	DllCall("QueryPerformanceCounter", "Int64*", CounterAfter := 0)
	; MsgBox "Elapsed QPC time is "  (CounterAfter - CounterBefore) / freq * 1000 " ms" ; debug view output from docs

	return delay_time := (CounterAfter - CounterBefore) / freq * 1000
	listlines, on
}
;///////////////////////////////////////////////////////////////////////////
WaitForNpp()
{
if Winactive("ahk_exe Notepad++.exe")
    sleep 250
}

; -[--- End of X:\AHK\xINC\FUNCs\Func(Clipboard).ahk ---]-

; -[--- Start of X:\AHK\xINC\FUNCs\GetFileIcon().ahk ---]-

;; get file icon function ;; getfileicon function ;; GetFileIcon() ;; function
/*
GetFileIcon(File) { ;; , been using this one for months but returns blury icons about 24 px
    ; listlines, off
    global iconerror
    VarSetCapacity(FileInfo, A_PtrSize + 688, 0)
    Flags := 0x101  ; SHGFI_ICON and SHGFI_SMALLICON
    if DllCall("shell32\SHGetFileInfoW", "WStr", File, "UInt", 0, "Ptr", &FileInfo, "UInt", A_PtrSize + 688, "UInt", Flags) {
        hIcon := NumGet(FileInfo, 0, "UPtr")
        if hIcon != 0
            return "HICON:" hIcon
    }
    ; Fallback if icon retrieval fails
    return %iconerror%  ; ? iconerror : A_AhkPath
    ; listlines, on
}
*/


GetFileIcon(File, Size := 24)  ;; USE ME , produces clear icons above 24px, 
{ ;; v.2026.03.31 - 2 
    ; GetFileIcon(file) ;; USAGE
    ; GetFileIcon(file,42)
    ; GetFileIcon(file,64)
    ; GetFileIcon(file,256)
    global iconerror

    ; if file doesn't exist, return error icon immediately
    if !FileExist(File)
        return iconerror

    ; map size to SHIL index
    if (Size <= 16)
        shil := 1
    else if (Size <= 32)
        shil := 0
    else if (Size <= 48)
        shil := 2
    else
        shil := 4

    GUID := "{46EB5926-582E-4017-9FDF-E8998DAA0950}"
    VarSetCapacity(iid, 16)
    DllCall("ole32\CLSIDFromString", "wstr", GUID, "ptr", &iid)
    if !DllCall("shell32\SHGetImageList", "int", shil, "ptr", &iid, "ptr*", pImageList)
    {
        VarSetCapacity(FileInfo, A_PtrSize + 688, 0)
        Flags := 0x100 | 0x4000
        DllCall("shell32\SHGetFileInfoW"
            , "wstr", File, "uint", 0
            , "ptr", &FileInfo
            , "uint", A_PtrSize + 688
            , "uint", Flags)
        iconIndex := NumGet(FileInfo, A_PtrSize, "int")
        hIcon := DllCall("comctl32\ImageList_GetIcon"
            , "ptr", pImageList
            , "int", iconIndex
            , "uint", 0, "ptr")
        if hIcon
            return "HICON:" hIcon
    }

    ; fallback
    VarSetCapacity(FileInfo, A_PtrSize + 688, 0)
    Flags := (Size <= 16) ? 0x101 : 0x100
    if DllCall("shell32\SHGetFileInfoW"
        , "wstr", File, "uint", 0
        , "ptr", &FileInfo
        , "uint", A_PtrSize + 688
        , "uint", Flags)
    {
        hIcon := NumGet(FileInfo, 0, "UPtr")
        if hIcon
            return "HICON:" hIcon
    }

    return iconerror
}

GetFileTypeIcon(ext, Size := 24) ;; USE ME , produces clear icons above 24px, 
{
; GetFileTypeIcon("mp3")     ; returns system icon for .mp3 files
; GetFileTypeIcon("pdf", 48) ; large pdf icon
; GetFileTypeIcon("ahk", 16) ; small ahk icon
    global iconerror

    ; map size to SHIL index
    if (Size <= 16)
        shil := 1
    else if (Size <= 32)
        shil := 0
    else if (Size <= 48)
        shil := 2
    else
        shil := 4

    ; fake filename with just the extension - file doesn't need to exist
    fakeFile := "file." ext

    GUID := "{46EB5926-582E-4017-9FDF-E8998DAA0950}"
    VarSetCapacity(iid, 16)
    DllCall("ole32\CLSIDFromString", "wstr", GUID, "ptr", &iid)
    if !DllCall("shell32\SHGetImageList", "int", shil, "ptr", &iid, "ptr*", pImageList)
    {
        VarSetCapacity(FileInfo, A_PtrSize + 688, 0)
        Flags := 0x100 | 0x4000 | 0x10  ; SHGFI_ICON | SHGFI_SYSICONINDEX | SHGFI_USEFILEATTRIBUTES
        DllCall("shell32\SHGetFileInfoW"
            , "wstr", fakeFile, "uint", 0x80  ; FILE_ATTRIBUTE_NORMAL
            , "ptr", &FileInfo
            , "uint", A_PtrSize + 688
            , "uint", Flags)
        iconIndex := NumGet(FileInfo, A_PtrSize, "int")
        hIcon := DllCall("comctl32\ImageList_GetIcon"
            , "ptr", pImageList
            , "int", iconIndex
            , "uint", 0, "ptr")
        if hIcon
            return "HICON:" hIcon
    }

    return iconerror
}


; Usage examples
; ico1 := GetFileIcon("C:\Windows\System32\notepad.exe", "small")
; ico2 := GetFileIcon("C:\Windows\System32\notepad.exe", "large")
; ico3 := GetFileIcon("C:\Icons\custom.ico", 64)  ; force 64×64 load


;===========================================================================
;===========================================================================
;===========================================================================

; -[--- End of X:\AHK\xINC\FUNCs\GetFileIcon().ahk ---]-

; -[--- Start of X:\AHK\xINC\MENU\A_VarMenu(DropIn).ahk ---]-

; ShowVarMenu()
/* 
;; USAGE
check you A_var in line via any your building.
call the menu then attach it
eg..
BuildVarMenu()
Menu, Tray, Built in A_Vars =, :var

or inside label:\func() eg.. a context menu ..

GuiContextMenu:
Menu, MyMenu, add, your layout, label
BuildVarMenu()
Menu, MyMenu, Inline A_Vars =, :var
*/
;---------------------------------------------------------------------------

ShowVarMenu()
{
    BuildVarMenu()
    menu, var, show
    return
}


;---------------------------------------------------------------------------
AttachVarMenu(MenuName)
{
    BuildVarMenu()
    Menu, %MenuName%, Add, Built in A_Vars`t=,:var
    Menu, %MenuName%, Icon, Built in A_Vars`t=, %A_AhkPath%,,16 ;%is%
}
;---------------------------------------------------------------------------

BuildVarMenu()
{
Menu, tray, UseErrorLevel, on
menu, var, add
menu, var, deleteall
menu, var, add, AHKs BUILT IN `%VARIABLES`% MENU, ShowVarMenu
menu, var, icon, AHKs BUILT IN `%VARIABLES`% MENU, %A_AHKPath%
menu, var, Default, AHKs BUILT IN `%VARIABLES`% MENU
menu, var, add, ; line -------------------------

menu, var1, add
menu, var1, DELETEALL
menu, var1, add, A_AhkPath=`t%A_AhkPath%, VarHandleDI
menu, var1, add, A_AhkVer=`t%A_AhkVersion%, VarHandleDI
menu, var1, add, A_Args=`t%A_Args%, VarHandleDI
menu, var1, add, A_ExitReason=`t%A_ExitReason%, VarHandleDI
menu, var1, add, A_InitialWorkingDir=`t%A_InitialWorkingDir%, VarHandleDI ; causes error
menu, var1, add, A_IsCompied=`t%A_IsCompiled%, VarHandleDI
menu, var1, add, A_IsUnicode=`t%A_IsUnicode%, VarHandleDI
menu, var1, add, A_LineNumber=`t%A_LineNumber%, VarHandleDI
menu, var1, add, A_LineFile=`t%A_LineFile%, VarHandleDI
menu, var1, add, A_ScriptDir=`t%A_ScriptDir%, VarHandleDI
menu, var1, add, A_ScriptFullPath=`t%A_ScriptFullPath%, VarHandleDI
menu, var1, add, A_ScriptHwnd=`t%A_ScriptHwnd%, VarHandleDI
menu, var1, add, A_ScriptName=`t%A_ScriptName%, VarHandleDI
menu, var1, add, A_ThisFucn=`t%A_ThisFunc%, VarHandleDI
menu, var1, add, A_ThisLabel=`t%A_ThisLabel%, VarHandleDI
menu, var1, add, A_WorkingDir=`t%A_WorkingDir%, VarHandleDI
menu, var, add,  SCRIPT PROPERTIES, :var1
 

menu, var, add, ; line -------------------------

menu, var3, add,
menu, var3, deleteall
menu, var3, add, A_AutoTrim=`t%A_AutoTrim%, VarHandleDI
menu, var3, add, A_BatchLines=`t%A_BatchLines%, VarHandleDI
menu, var3, add, A_ControlDelay=`t%A_ControlDelay%, VarHandleDI
menu, var3, add, A_CoordModePixel=`t%A_CoordModePixel%, VarHandleDI
menu, var3, add, A_CoordModeCaret=`t%A_CoordModeCaret%, VarHandleDI
menu, var3, add, A_CoordModeMenu=`t%A_CoordModeMenu%, VarHandleDI
menu, var3, add, A_CoordModeMouse=`t%A_CoordModeMouse%, VarHandleDI
menu, var3, add, A_CoordModeToolTip=`t%A_CoordModeToolTip%, VarHandleDI
menu, var3, add, A_DefaultMouseSpeed=`t%A_DefaultMouseSpeed%, VarHandleDI
menu, var3, add, A_DetectHiddenText=`t%A_DetectHiddenText%, VarHandleDI
menu, var3, add, A_DetectHiddenWindows=`t%A_DetectHiddenWindows%, VarHandleDI
menu, var3, add, A_FileEncoding=`t%A_FileEncoding%, VarHandleDI
menu, var3, add, A_FormatFloat=`t%A_FormatFloat%, VarHandleDI
menu, var3, add, A_FormatInteger=`t%A_FormatInteger%, VarHandleDI
menu, var3, add, A_IconFile=`t%A_IconFile%, VarHandleDI
menu, var3, add, A_IconHidden=`t%A_IconHidden%, VarHandleDI
menu, var3, add, A_IconNumber=`t%A_IconNumber%, VarHandleDI
menu, var3, add, A_IconTip=`t%A_IconTip%, VarHandleDI
menu, var3, add, A_IsCritical=`t%A_IsCritical%, VarHandleDI
menu, var3, add, A_IsPaused=`t%A_IsPaused%, VarHandleDI
menu, var3, add, A_IsSuspended=`t%A_IsSuspended%, VarHandleDI
menu, var3, add, A_KeyDelay=`t%A_KeyDelay%, VarHandleDI
menu, var3, add, A_KeyDelayPlay=`t%A_KeyDelayPlay%, VarHandleDI
menu, var3, add, A_KeyDuration=`t%A_KeyDuration%, VarHandleDI
menu, var3, add, A_KeyDurationPlay=`t%A_KeyDurationPlay%, VarHandleDI
menu, var3, add, A_ListLines=`t%A_ListLines%, VarHandleDI
menu, var3, add, A_MouseDelay=`t%A_MouseDelay%, VarHandleDI
menu, var3, add, A_MouseDelayPlay=`t%A_MouseDelayPlay%, VarHandleDI
menu, var3, add, A_RegView=`t%A_RegView%, VarHandleDI
menu, var3, add, A_SendLevel=`t%A_SendLevel%, VarHandleDI
menu, var3, add, A_SendMode=`t%A_SendMode%, VarHandleDI
menu, var3, add, A_StoreCapsLockMode=`t%A_StoreCapsLockMode%, VarHandleDI
menu, var3, add, A_StringCaseSense=`t%A_StringCaseSense%, VarHandleDI
menu, var3, add, A_TitleMatchMode=`t%A_TitleMatchMode%, VarHandleDI
menu, var3, add, A_TitleMatchModeSpeed=`t%A_TitleMatchModeSpeed%, VarHandleDI
menu, var3, add, A_WinDelay=`t%A_WinDelay%, VarHandleDI
Menu, var3, add, ; line -------------------------
Menu, var3, add, A_LastError=`t%A_LastError%, VarHandleDI
Menu, var3, add, ErrorLevel=`t%ErrorLevel%, VarHandleDI

; menu, var, add, SCRIPT SETTINGS, :var3
menu, var, add, Script Parameters, :var3
menu, var, add, ; line -------------------------
 
 
menu, var4, add,
menu, var4, deleteall
menu, var4, add, A_TimeIdle=`t%A_TimeIdle%, VarHandleDI
menu, var4, add, A_TimeIdleKeyboard=`t%A_TimeIdleKeyboard%, VarHandleDI
menu, var4, add, A_TimeIdlePhysical=`t%A_TimeIdlePhysical%, VarHandleDI
menu, var4, add, A_TimeIdleMouse=`t%A_TimeIdleMouse%, VarHandleDI
menu, var, add, User Idle Time, :var4


menu, var, add, ; line -------------------------


menu, var5, add,
menu, var5, deleteall
menu, var5, add, A_EndChar=`t%A_EndChar%, VarHandleDI
menu, var5, add, A_PriorHotkey=`t%A_PriorHotkey%, VarHandleDI
menu, var5, add, A_PriorKey=`t%A_PriorKey%, VarHandleDI
menu, var5, add, A_ThisHotkey=`t%A_ThisHotkey%, VarHandleDI
menu, var5, add, A_ThisMenu=`t%A_ThisMenu%, VarHandleDI
menu, var5, add, A_ThisMenuItem=`t%A_ThisMenuItem%, VarHandleDI
menu, var5, add, A_ThisMenuItemPos=`t%A_ThisMenuItemPos%, VarHandleDI
menu, var5, add, A_TimeSincePriorHotkey=`t%A_TimeSincePriorHotkey%, VarHandleDI
menu, var5, add, A_TimeSinceThisHotkey=`t%A_TimeSinceThisHotkey%, VarHandleDI
menu, var, add, Hotkeys`, Hotstrings`, and Custom Menu Items, :var5
menu, var, add, ; line -------------------------


 
menu, var6, add,
menu, var6, deleteall
menu, var6, add, A_AppData=`t%A_AppData%, VarHandleDI
menu, var6, add, A_AppDataCommon=`t%A_AppDataCommon%, VarHandleDI
menu, var6, add, A_ComputerName=`t%A_ComputerName%, VarHandleDI
menu, var6, add, A_ComSpec=`t%A_ComSpec%, VarHandleDI
menu, var6, add, A_Desktop=`t%A_Desktop%, VarHandleDI
menu, var6, add, A_DesktopCommon=`t%A_DesktopCommon%, VarHandleDI
menu, var6, add, A_Is64bitOS=`t%A_Is64bitOS%, VarHandleDI
menu, var6, add, A_IsAdmin=`t%A_IsAdmin%, VarHandleDI
Menu, var6, add, A_IPAddress1=`t%A_IPAddress1%, VarHandleDI
Menu, var6, add, A_IPAddress2=`t%A_IPAddress2%, VarHandleDI
Menu, var6, add, A_IPAddress3=`t%A_IPAddress3%, VarHandleDI
Menu, var6, add, A_IPAddress4=`t%A_IPAddress4%, VarHandleDI
menu, var6, add, A_Language=`t%A_Language%, VarHandleDI
menu, var6, add, A_MyDocuments=`t%A_MyDocuments%, VarHandleDI
menu, var6, add, A_OSType=`t%A_OSType%, VarHandleDI
menu, var6, add, A_OSVersion=`t%A_OSVersion%, VarHandleDI
menu, var6, add, A_ProgramFiles=`t%A_ProgramFiles%, VarHandleDI
menu, var6, add, A_PtrSize=`t%A_PtrSize%, VarHandleDI
menu, var6, add, A_ScreenDPI=`t%A_ScreenDPI%, VarHandleDI ; causes error
menu, var6, add, A_ScreenHeight=`t%A_ScreenHeight%, VarHandleDI
menu, var6, add, A_ScreenWidth=`t%A_ScreenWidth%, VarHandleDI
menu, var6, add, A_Temp=`t%A_Temp%, VarHandleDI
menu, var6, add, A_UserName=`t%A_UserName%, VarHandleDI
menu, var6, add, A_WinDir=`t%A_WinDir%, VarHandleDI

menu, var6a, add,
menu, var6a, deleteall
    menu, var6a, add, A_ProgramCommon=`t%A_ProgramsCommon%, VarHandleDI
    menu, var6a, add, A_Programs=`t%A_Programs%, VarHandleDI
    menu, var6a, add, A_StartMenu=`t%A_StartMenu%, VarHandleDI
    menu, var6a, add, A_StartMenuCommon=`t%A_StartMenuCommon%, VarHandleDI
    menu, var6a, add, A_StartUp=`t%A_Startup%, VarHandleDI
    menu, var6a, add, A_StartupCommon=`t%A_StartupCommon%, VarHandleDI

    Menu, var6, add, ; line -------------------------
Menu, var6, add, Long Paths`t++ >>>, :var6a
Menu, var6, Icon, Long Paths`t++ >>>, %icons%\attention.ico


; if (A_UserName = "CLOUDEN")
; {
    ; Menu, var6, add, ; line -------------------------
    ; Menu, var6, add, xNote!`t6 Items R -H 4 short ≡, dummy
    ; Menu, var6, Icon, xNote!`t6 Items R -H 4 short ≡, %icons%\attention.ico
; }
; ELSE
; {
    ; menu, var6, add, A_ProgramCommon=`t%A_ProgramsCommon%, VarHandleDI
    ; menu, var6, add, A_Programs=`t%A_Programs%, VarHandleDI
    ; menu, var6, add, A_StartMenu=`t%A_StartMenu%, VarHandleDI
    ; menu, var6, add, A_StartMenuCommon=`t%A_StartMenuCommon%, VarHandleDI
    ; menu, var6, add, A_StartUp=`t%A_Startup%, VarHandleDI
    ; menu, var6, add, A_StartupCommon=`t%A_StartupCommon%, VarHandleDI
; }

menu, var, add, Operating System and User Info, :var6
menu, var, add, ; line -------------------------

menu, var7, add,
menu, var7, deleteall

menu, var7, add, A_DefaultGui=`t%A_DefaultGui%, VarHandleDI
menu, var7, add, A_DefaultListView=`t%A_DefaultListView%, VarHandleDI
menu, var7, add, A_DefaultTreeView=`t%A_DefaultTreeView%, VarHandleDI
menu, var7, add, A_EventInfo=`t%A_EventInfo%, VarHandleDI
menu, var7, add, A_GUI=`t%A_Gui%, VarHandleDI
menu, var7, add, A_GuiControl=`t%A_GuiControl%, VarHandleDI
menu, var7, add, A_GuiEvent=`t%A_GuiEvent%, VarHandleDI
menu, var7, add, A_GuiHeight=`t%A_GuiHeight%, VarHandleDI
menu, var7, add, A_GuiWidth=`t%A_GuiWidth%, VarHandleDI
menu, var7, add, A_GuiX=`t%A_GuiX%, VarHandleDI
menu, var7, add, A_GuiY=`t%A_GuiY%, VarHandleDI
Menu, var, add, GUI Windows and Menu Bars, :var7
menu, var, add, ; line -------------------------

menu, var8, add,
menu, var8, deleteall

Menu, var8, add, A_Cursor=`t%A_Cursor%, VarHandleDI
Menu, var8, add, A_CaretX=`t%A_CaretX%, VarHandleDI
Menu, var8, add, A_CaretY=`t%A_CaretY%, VarHandleDI
Menu, var8, add, ; line -------------------------
Menu, var8, add, A_Index=`t%A_Index%, VarHandleDI
Menu, var8, add, A_LoopFileName=`t%A_LoopFileName%, VarHandleDI
Menu, var8, add, A_LoopRegName=`t%A_LoopRegName%, VarHandleDI
Menu, var8, add, A_LoopReadLine=`t%A_LoopReadLine%, VarHandleDI
Menu, var8, add, A_LoopField=`t%A_LoopField%, VarHandleDI

Menu, var, add, MISC && Loops, :var8
menu, var, add, ; line -------------------------
menu, var2, add
menu, var2, deleteall
menu, var2, add, A_YYYY=`t%A_YYYY%, VarHandleDI
menu, var2, add, A_MM=`t%A_MM%, VarHandleDI
menu, var2, add, A_DD=`t%A_DD%, VarHandleDI
menu, var2, add, A_MMMM=`t%A_MMMM%, VarHandleDI
menu, var2, add, A_MMM=`t%A_MMM%, VarHandleDI
menu, var2, add, A_DDDD=`t%A_DDDD%, VarHandleDI
menu, var2, add, A_DDD=`t%A_DDD%, VarHandleDI
menu, var2, add, A_WDay=`t%A_WDay%, VarHandleDI
menu, var2, add, A_YDay=`t%A_YDay%, VarHandleDI
menu, var2, add, A_YWeek=`t%A_YWeek%, VarHandleDI
menu, var2, add, A_Hour=`t%A_Hour%, VarHandleDI
menu, var2, add, A_Min=`t%A_Min%, VarHandleDI
menu, var2, add, A_Sec=`t%A_Sec%, VarHandleDI
menu, var2, add, A_MSec=`t%A_MSec%, VarHandleDI
menu, var2, add, A_Now=`t%A_Now%, VarHandleDI
menu, var2, add, A_NowUTC=`t%A_NowUTC%, VarHandleDI
menu, var2, add, A_TickCount=`t%A_TickCount%, VarHandleDI
menu, var, add, DATE && TIME, :var2
;  Date and Time%, VarHandleDI

menu, var, add, ; line -------------------------
menu, var, add, Visit Built in A_Vars Doc Webpage, visitbuiltindocs
menu, var, icon, Visit Built in A_Vars Doc Webpage, C:\Windows\system32\netshell.dll, 86
; menu, var, add, Run Adventures IDE A_Var Tool, runvartool
; menu, var, icon, Run Adventures IDE A_Var Tool, X:\XI\icons extracted from software\autogui icons\A_Variables.ico
; menu, var, add, ; line -------------------------
; menu, var, add, Click=Copy Value`, +=Copy Menu Item, ShowVarMenu
; menu, var, icon, Click=Copy Value`, +=Copy Menu Item, %icons%\about.ico
Menu, tray, UseErrorLevel, off
}

VarHandleDI()
{
    ; box(A_thismenuitem)
    clipboard =
    sleep 40
    Clipboard := A_ThisMenuItem
    clipwait,0.5
    If (clipboard != "")
    {
        Tip("Copied=" clipboard, 2500)
    }
; if GetKeyState("Shift", "P")
	; {
		; return
	; }
    return
}
visitbuiltindocs()
{
run https://www.autohotkey.com/docs/v1/Variables.htm#BuiltIn
return
}
; clickedValue := SubStr(A_ThisMenuItem, InStr(A_ThisMenuItem, ":") + 1) ; Retrieve the value of the clicked menu item

; if (Trim(clickedValue) = "") { ; Check if the value is empty
    ; Tooltip, There is nothing here to copy.
    ; SetTimer, RemoveToolTip, -1500
    ; Return
; }

; Clipboard := "" ; Otherwise, copy the value to the clipboard
; Sleep 20
; Clipboard := Trim(clickedValue)
; Return



; -[--- End of X:\AHK\xINC\MENU\A_VarMenu(DropIn).ahk ---]-

;===========================================================================
;===========================================================================
;===========================================================================

global AHKFilePath := "" ;; for live hotkeys in file menu
global xtime := ""
xtime()
{
    FormatTime, XTime, %date%, yyyy/MM/dd HH:mm tt
}
ExpandVars(str) {
    Transform, result, Deref, %str%
    return result
}

;===========================================================================
;===========================================================================
;===========================================================================

GetFullPath(path) {  ;; GetFullPathFromRelative
    VarSetCapacity(buf, 260 * 2)
    DllCall("GetFullPathName", "str", path, "uint", 260, "str", buf, "ptr", 0)
    return buf     ;; usage ==>  global mainscript := GetFullPath(A_ScriptDir "\..\xxx.ahk")
}

;===========================================================================
;===========================================================================
;===========================================================================
/*

 tip(msg, rtt := "")  ;; tip() ;; fucnction ;; fun ; 5000
{
    global AutoClearTooltips, ClearToolTipTimer
    if (AutoClearTooltips) ;; in ini [WindowManagerSettings]
        rtt := ClearToolTipTimer ;        rtt := 5000
    ; else 
        ; rtt := 0

if (rtt > 0)
    {
        Tooltip, %msg%
        SetTimer, RemoveTooltip, %rtt%
    }
else
    Tooltip, %msg%    
} 

*/
global ClearToolTipTimer
global rtt := ""

; #include X:\AHK\Lib\ToolTips(CustomFontsColors).ahk ;; sadly is global, too much wtf ahk to bother with
    ; tipFont("s11", "Hack")
    ; TipColor("272727","bbbbbb")
tip(msg, rtt := "")  ;; tip() ;; fucnction ;; fun ; 5000
{
    static hfont := 0, bc := "", tc := ""
    global AutoClearTooltips, ClearToolTipTimer
    if (rtt = "") && (AutoClearTooltips) ;; in ini [WindowManagerSettings]
        rtt := ClearToolTipTimer ;        rtt := 5000
    if (rtt > 0)
    {
        Tooltip, %msg%
        SetTimer, RemoveTooltip, %rtt%
    }
    else
        Tooltip, %msg%
}

RemoveToolTip() ;; function
{
	ToolTip
}
global to
box(msg, to := 0) { ;; my msgbox function  ;; box() ;; function Box("test", 1000)
SetTimer, AutoMsgBoxButtons_Func, -50 ;; for 2 buttons
if (to > 0)
    MsgBox, 262404, - xMsg - %A_ScriptName%, %msg%, %to%  ;; for 2 buttons Yes/No
else
    MsgBox, 262404, - xMsg - %A_ScriptName%, %msg%  ;; for 2 buttons Yes/No
        
IfMsgBox Yes ;Copy ;YES(on 3 buttons) ;OK(on 2 buttons)
	{
        clipboard = 
        sleep 30
        clipboard := msg
        ClipWait,0.5
        if Clipboard !=
        {
            tooltip, Copied...`n  %msg%
            SetTimer, RemoveToolTip, -2500
        }
	}
IfMsgBox No
	{
        
	}
IfMsgBox Cancel
	{
	
	}
IfMsgBox Timeout
	{
	
	}
Return
}

AutoMsgBoxButtons_Func() {     ; global A_ScriptName ;; causes ahk error
    IfWinNotExist, - xMsg - %A_ScriptName%
        return
    
    SetTimer, AutoMsgBoxButtons_Func, Off
    WinActivate
    ControlSetText, Button1, &Copy
    ControlSetText, Button2, &OK
    return
}


; INIReadSection_OG_(sectionName)
; { ;; KEEP FOR REFEARNCE OR FALLBACK
    ; global
    ; IniRead, SectionContent, %inifile%, %sectionName%
    ; if (SectionContent = "ERROR")
    ; {
        ; tooltip ERR! reading [%sectionName%]
        ; return
    ; }
    ; Loop, Parse, SectionContent, `n, `r
    ; {
        ; if (A_LoopField = "")
            ; continue
        ; KeyParts := StrSplit(A_LoopField, "=")
        ; if (KeyParts.Length() < 2)
            ; continue
        ; VarName := Trim(KeyParts[1])
        ; VarValue := Trim(KeyParts[2])
        ; if (VarValue = "" || VarValue = "ERROR")
            ; VarValue := (sectionName = "Settings") ? 0 : ""
        ; VarName := RegExReplace(VarName, "[^A-Za-z0-9_]", "_")
        ; VarName := RegExReplace(VarName, "^[0-9]+", "")
        ; VarName := RegExReplace(VarName, "_+", "_")
        ; VarName := Trim(VarName, "_")
        ; if (VarName = "")
            ; VarName := "var_" A_TickCount
        ; %VarName% := VarValue
    ; }
    ; if fileExist(texteditor)
    ; {
        ; splitpath, texteditor, TE_Name, TE_Dir, , TE_Stem, TE_Drive
        ; TE := texteditor
    ; }
; }
INIReadSection(sectionName)
{ ;; version 3 with auto error correcting
    global
    LISTLINES, OFF
    IniRead, SectionContent, %inifile%, %sectionName%
    if (SectionContent = "ERROR")
    {
        tooltip ERR! reading [%sectionName%] `n %A_LineFile% Line#: %A_LineNumber%
        return
    }

    Loop, Parse, SectionContent, `n, `r
    {
        if (A_LoopField = "")
            continue

        KeyParts := StrSplit(A_LoopField, "=")
        if (KeyParts.Length() < 2)
            continue

        VarName  := Trim(KeyParts[1])
        VarValue := Trim(KeyParts[2])

        if (VarValue = "" || VarValue = "ERROR")        ; Default empty settings to 0 for "Settings" section
            VarValue := (sectionName = "Settings") ? 0 : ""

        ; ====== 🔥 AUTO-CONVERT INVALID VAR NAMES ======
        VarName := RegExReplace(VarName, "[^A-Za-z0-9_]", "_")        ; Replace invalid characters with "_"
        ; VarName := RegExReplace(VarName, "^[0-9]+", "")        ; Remove leading numbers
        VarName := RegExReplace(VarName, "_+", "_")        ; Collapse multiple underscores
        VarName := Trim(VarName, "_")        ; Trim leftover underscores

        if (VarName = "")        ; Ensure variable name is not empty
            VarName := "var_" A_TickCount

        ; ===============================================


        %VarName% := VarValue        ; 🔥 Create the global variable dynamically // xAdded Global tag 12-07-2025
        if fileExist(texteditor)
            {
                splitpath, texteditor, TE_Name, TE_Dir, , TE_Stem, TE_Drive
                TE := texteditor
            }   ; box("te=" te "`ntexteditor=" texteditor)
        If FileExist(iniTextEditor)
        {
            splitpath, iniTextEditor, iniTE_Name, iniTE_Dir, , iniTE_Stem, iniTE_Drive

            iniTE := iniTextEditor
            splitpath, iniTE, iniefilename ; #todo , clean this up in about 4 files this now should be handled in x[env], shitty naming, using this in a few menus
            
        }
    }
    listlines, on
}

global iniefilename
global TE := texteditor


INIGroupAdd(groupName, iniSection := "Config_aJump") {
    global IniFile
    IniRead, exeList, %IniFile%, %iniSection%, GroupAdd_%groupName%_exe, %A_Space%    ; Read exe list
    Loop, Parse, exeList, |
    {
        exe := Trim(A_LoopField)
        if (exe != "")
            GroupAdd, %groupName%, ahk_exe %exe%
    }
    IniRead, classList, %IniFile%, %iniSection%, GroupAdd_%groupName%_class, %A_Space%    ; Read class list
    Loop, Parse, classList, |
    {
        class := Trim(A_LoopField)
        if (class != "")
            GroupAdd, %groupName%, ahk_class %class%
    }
}


dummy()
{
    return
}



;; ==================================================
;; Moved from = %A_scriptdir%\xINC\MENU\Hotkeys In File.ahk = 12/01/2025 @ 16:05 PM
;; ==================================================
;---------------------------------------------------------------------------
; Use the current script’s line + file
; OpenTEToLine(A_LineFile, A_LineNumber)

; Or open something else
; OpenTEToLine("C:\Temp\mycode.ahk", 77)

; ; OpenTextEditorToLine(file, line) {
OpenTEToLine(file, line) { ; OpenTEToLine() ;; function
    global TE_Name, SciTE, vscode, notepadpp, ahkstudio, notepad4, sublimetext, texteditor, iniTextEditor, geany, zed,
    splitpath, texteditor, TE_Name
    splitpath, iniTextEditor, iniTE_Name, iniTE_Dir, , iniTE_Stem, iniTE_Drive ;; og keep
            ; box("text has a jumper!`ntext=" text "`nline=" line "`nfile=" file)
    ; splitpath, iniTextEditor, TE_Name, TE_Dir, , TE_Stem, TE_Drive
    splitpath, file, ,,ext
    if (ext = "ini")  ;; #todo this needs better inite vs te logic
    {
        if (iniTE_name = "Notepad4.exe")
            run, %iniTextEditor% /g %Line% "%File%"    ; run, %inieditor%
        else
            try run, %iniTextEditor% "%File%"
        catch
            try run "%File%"
        return
    }
	root := A_ScriptDir
    if (TE_Name = "SciTE.exe")
        Run, "%SciTE%" -goto:%line% "%file%"
    else if (TE_Name = "VSCodium.exe") || (TE_Name = "code.exe")
	{
        if (InStr(file, root) = 1)		; check if the file is inside the workspace folder
            ; Run, "%vscode%" -g "%file%:%line%" "%root%"
			Run, "%vscode%" --reuse-window -g "%file%:%line%"
        else
            Run, "%vscode%" -g "%file%:%line%"
	}
    else if (TE_Name = "Notepad++.exe")
        Run, "%notepadpp%" "%file%" -n%line%
    else if (TE_Name = "zed.exe")
        Run, %zed% "%file%:%line%"
    else if (TE_Name = "AHK-Studio.exe")
        {
            ; Run, "%ahkstudio%" "%file%" %line% ;; typical ahk-studio won't open to a line number.
            Run, "%ahkstudio%" "%file%"
            WinWaitActive, AHK Studio - ahk_exe AHK-Studio.exe
            send, ^g
            sleep 200
            send, %line%
            send, {enter}
            
        }
    else if (TE_Name = "notepad4.exe")
        Run, "%notepad4%" /g %line% "%file%"
    else if (TE_Name = "geany.exe")
        Run, "%geany%" -l %line% "%file%"
    else if (TE_Name = "sublime_text.exe")
        Run, "%sublimetext%" "%file%:%line%"
    else if (TE_Name = "Adventure.exe")
        Run, "%texteditor%" "%file%"
    else
		Try Run, "%texteditor%" "%file%"
	catch
        Run, notepad.exe "%file%"

}
;; ==================================================
OpenFileToFoundText(file,text:="")
	{
    global texteditor, notepad4, TE_name, vscode, sublimetext, targetfile, currentfile, te, iniTextEditor, gotosearch, geany, zed, filter
        searchText := text ; or can be a_var without quotes eg, A_file
        targetFile := file   ; or can be a file path in quotes
        foundLine := 0
        splitpath, targetfile, ,,ext
        splitpath, texteditor,TE_Name
        splitpath, iniTextEditor, iniTE_name
        FileRead, fileContents, %targetFile%
/*

 if RegExMatch(text, "i)^>>")
        {
            text := Trim(RegExReplace(text, ">>"))
            ; box("text has a jumper!`n" text "`nfile=" file)
            line := text
            OpenTEToLine(file, line)
            return
        } 

*/
        
    if RegExMatch(text, "i)^>>", m)
    {
        text := Trim(RegExReplace(text, "^>>"))
        OpenTEToLine(file, text)
        return
    }
        Loop, Parse, fileContents, `n, `r
        {
            if InStr(A_LoopField, searchText) {
                foundLine := A_Index
                break
            }
        }
        ;; this needs a if (Text := "")
            ;; just run %te% "%targetfile%"
        if !(searchText)
        {
            run, %texteditor% "%targetFile%"
            return
        }
        if !(foundline)
        {
            run, %texteditor% "%targetFile%"
            return
        }
        if (foundLine > 0)
        {
            ; tip(ext)
            if (ext = "ini")  ;; #todo this needs better inite vs te logic
            {
                if (iniTE_name = "Notepad4.exe")
                    run, %iniTextEditor% /g %foundLine% "%targetFile%"    ; run, %inieditor%
                else
                    try run, %te% "%targetFile%"
                catch
                    try run "%targetFile%"
                return
            }
            else
            {
            if (TE_Name = "notepad++.exe")
                Run, notepad++.exe "%targetFile%" -n%foundLine%
            else if (TE_Name = "VSCodium.exe")
                Run, %vscode% -g "%targetFile%:%foundLine%"
            else if (TE_Name = "sublime_text.exe")
                Run, %sublimetext% "%targetFile%:%foundLine%"
            else if (TE_Name = "zed.exe")
                Run, %zed% "%targetFile%:%foundLine%"
            else if (TE_Name = "geany.exe")
                Run, "%geany%" -l %foundLine% "%targetFile%"
            else if (TE_Name = "notepad4.exe")
                run, %notepad4% /g %foundLine% "%targetFile%"
            ; else
                ; run, %texteditor% "%targetFile%"
            }
        }
        ; else
            ; run, %texteditor% "%targetFile%"
            ; run, notepad.exe "%targetFile%"
		return
	}
    
    









;; ==================================================
;; Moved from = %A_scriptdir%\xxx.ahk = 12/12/2025 @ 16:54 PM =
;; ==================================================
;; process functions
; Function to check if a process exists
ProcessExist(exeName)  ;; ProcessExist() ;; Function
{
	Process, Exist, %exeName%
	return ErrorLevel ; Returns PID if running, otherwise 0
}
;; ==================================================



;; ==================================================
;; Moved from = %A_scriptdir%\xINC\IF\Notepad++.ahk = 12/17/2025 @ 11:29 AM =
;; ==================================================
FindAllInNpp(filepath,text)
{
    global find, this, tip, notepadpp
    SplitPath, filepath, name, dir, ext, stem
    SetTitleMatchMode, 2
    ; tip("Running N++ from " A_ThisFunc "() to Search...`n`nfilepath=" filepath "`nname=" name "`ntext=" text, 3000)
    
    Run, %notepadpp% "%filepath%"
	WinWaitActive, %name% - Notepad++ ahk_class Notepad++ ahk_exe notepad++.exe,,7
	if ErrorLevel
		{
            tip("what the fuck ahk!`nWaiting for " name " - Notepad++`nHas Errored Out! Check your spelling in the filepath being sent, ITs CaseSensitive!", 7000)
            return
        }
    sleep 300
	send, ^f
	WinWaitActive, Find ahk_class #32770 ahk_exe notepad++.exe,,3
		if ErrorLevel
		{
            tip("what the fuck ahk!`nWaiting for Find ahk_class #32770 ahk_exe notepad++.exe", 7000)
            return
        }
	sleep 200
    ControlSetText, Edit1, %text%, A
    ControlClick, Find All in Current &Document, A,,left,1,na
    sleep 100
    WinActivate, Find ahk_class #32770 ahk_exe notepad++.exe ;; bring the focus back to the Find Window
    sleep 100
    ControlClick, ▼ Find Next, A,,left,1,na ;; now click find next sends, {enter} without the keys stroke
    WinActivate, ahk_class Notepad++ ahk_exe notepad++.exe
    return
}
;; ==================================================

;; ==================================================
;; Moved from = %A_scriptdir%\xINC\GUI\Dash.ahk = 12/17/2025 @ 12:05 PM =
;; ==================================================
ToggleScript(filepath)
{
    DetectHiddenWindows, On 
    global ahk, xinc, atemp
    splitpath, filepath, name,,ext
    If !FileExist(filepath)
    {
        tip("The provided filepath cannot be found.`n" filepath, 3500)
        return
    }
    if (ext = "exe")
    {
        if ProcessExist(name)
            Run, taskkill /f /im %name%,, Hide
        else
            run, %filepath%
    }
    else if (ext = "ahk")
    {    ; Closing/Opening all scripts
        if (WinExist(filepath " ahk_class AutoHotkey"))
        {
            WinClose, %filepath% ahk_class AutoHotkey
        } 
        else 
        {
            Run, %filepath%
        }
    }
    Else
    {
        tip("This Function only works with .exes or .ahks`nOR`nFilepath was not found`n" filepath, 5000)
    }

    DetectHiddenWindows, Off
    return
}
;; ==================================================
Menu, tray, UseErrorLevel, ON
global soloini := A_scriptdir "\" A_ScriptStem ".ini"
global localreadme := A_scriptdir "\readme.md"
global localscribbles := A_scriptdir "\" A_ScriptStem " Scribbles.md"
global localgithublink := A_scriptdir "\" A_scriptstem " - Github Link.url"
; menu, tray, add, ;line ;-------------------------
Menu, BugTray, add, Listlines`t[env], Listlines
Menu, BugTray, Icon, Listlines`t[env], %icons%\bug.ico,,%is%   ;,,16 ;,,%is%
Menu, BugTray, add, KeyHistory`t[env], KeyHistory
Menu, BugTray, Icon, KeyHistory`t[env], %icons%\bug.ico,,%is%   ;,,16 ;,,%is%
Menu, BugTray, add, ListHotkeys`t[env], ListHotkeys
Menu, BugTray, Icon, ListHotkeys`t[env], %icons%\bug.ico,,%is%   ;,,16 ;,,%is%
Menu, BugTray, add, ListVars`t[env], ListVars
Menu, BugTray, Icon, ListVars`t[env], %icons%\bug.ico,,%is%   ;,,16 ;,,%is%
menu, BugTray, add, ;line ;-------------------------
BuildVarMenu()
Menu, bugtray, add, A_Vars`t[env], :var
Menu, bugtray, Icon, A_Vars`t[env],  %A_AhkPath%,,%is% ;16 ;%is%,,%is%
;==================================================
BuildENVTrayMenu()

BuildENVTrayMenu()
{
global is, A_scriptstem, iie, soloini, source_stem, source_name, inisectionlist, iniSide_config, compiled_stem, CompileX, MenuIconSize, DevMode
Menu, tray, UseErrorLevel, ON
;; this is an inline include, or, past where needed from below

; buildtray() ;; call
; buildtray() ;; function
; {
; }
;; hmm, tricky
Menu, tray, NoStandard
    Menu, tray, add, Reload`t[env], reloadENV
    Menu, tray, Icon, Reload`t[env], %icons%\reloadcircle.ico,,%is%
    If FileEXIST(soloini)
    {
        Menu, tray, add, Edit Solo.ini`t[env], EditSoloIniENV
        Menu, tray, Icon, Edit Solo.ini`t[env], notepad.exe,,%is%
    
    }
    Menu, tray, add, Open A_ScriptDir`t[env], OpenScriptDirENV
    ; Menu, tray, Icon, Open A_ScriptDir, %icons%\DOpus_Spikes_256x256.ico,,%is%
    Menu, tray, Icon, Open A_ScriptDir`t[env], %icons%\explorer.ico,,%is%
    If FileExist(localgithublink)
    {
        Menu, tray, add, Visit Github Page`t[env], RunLocalGithubLinkENV
        Menu, tray, Icon, Visit Github Page`t[env], %icons%\githubicon.ico,,%is%
    }
    If FileExist(localreadme)
    {
        Menu, tray, add, View ReadMe.md`t[env], ViewReadMeENV
        readmeicon := GetFileIcon(localreadme)
        Menu, tray, Icon, View ReadMe.md`t[env], %readmeicon%,,%is%
    }
If FileExist(SourceScript) 
{
    Menu, tray, add, ; line -------------------------
    Menu, tray, add, Edit %source_name%`t[env], editSourceENV
    Menu, tray, Icon, Edit %source_name%`t[env], notepad.exe,,%is%
    if instr(inisectionlist, iniSide_config)
    {
        Menu, tray, add, INI Edit[Config_%A_ScriptStem%]`t[env], EditINIConfigENV ; EditINIConfigENV() ;; moved to x:\ahk\xinc\x[msg].ahk 03-09-2026
        If FileExist(iie)
            Menu, tray, Icon, INI Edit[Config_%A_ScriptStem%]`t[env], %iie%,,%is%
        else
            Menu, tray, Icon, INI Edit[Config_%A_ScriptStem%]`t[env], Notepad.exe,,%is%
    }
    IF FileExist(localscribbles)
    {
        Menu, tray, add, Scribbles!`t[env], ViewScribblesENV
        Menu, tray, Icon, Scribbles!`t[env], %icons%\scribbles-wastepaper.ico,,%is%
    }
    Menu, tray, add, ; line -------------------------
    If FileExist(CompiledScript) && FileExist(SourceScript)
    {
        if (A_IsCompiled)
        {
            Menu, tray, add, Switch to %source_stem%>> *.AHK`t[env], SwitchENV
            Menu, tray, Icon, Switch to %source_stem%>> *.AHK`t[env], %icons%\arrows switch.ico,,%is%
        }
        else
        {
            Menu, tray, add, Switch to %compiled_stem%>> *.EXE`t[env], SwitchENV
            Menu, tray, Icon, Switch to %compiled_stem%>> *.EXE`t[env], %icons%\arrows switch.ico,,%is%        
        }
        ; if ProcessExist(compiled_name) ; && !(A_IsCompiled)
        ; {
            ; Menu, tray, add, Kill Compiled App`t[env], Kill_CompiledScript
            ; Menu, tray, Icon, Kill Compiled App`t[env], %Icons%\skull_old_fatcow_32x32.ico,,%is%
        ; }
    }
    If FileExist(CompileX) ;  && FileExist(SourceScript) ;; if i share anything is very unlikely anyone else witll have my (compileX)
    {
        if (A_IsCompiled)
        {
            Menu, tray, add, > RE-CompileX && Run`t[env], CompileENV
            Menu, tray, Icon, > RE-CompileX && Run`t[env], %compilex% ;%icons%\compilex.ico ; %Icons%\packagescript.ico  ;%Icons%\compile4.ico,,%is%
        }
        else
        {
            Menu, tray, add, > CompileX && Run`t[env], CompileENV
            Menu, tray, Icon, > CompileX && Run`t[env], %compilex% ;%icons%\compilex.ico ; %Icons%\packagescript.ico  ;%Icons%\compile4.ico,,%is%
            ; box(compiled_name)
        }
    }
    Menu, tray, add, ; line -------------------------
    Menu, tray, add, Suspend Hotkeys`t[env],SuspendHotkeysENV
    Menu, tray, Icon, Suspend Hotkeys`t[env], %icons%\suspendhotkeys.ico,,%is%
    ; Menu, tray, add, Pause Script`t[env],PauseScriptENV
    ; Menu, tray, Icon, Pause Script`t[env], %icons%\pausescript.ico,,%is%
    Menu, tray, add, Quit\Kill\Exit`t[env], quitENV
    ; Menu, tray, Icon, Quit\Kill\Exit`t[env], %Icons%\skull_old_fatcow_32x32.ico,,%is%
    Menu, tray, Icon, Quit\Kill\Exit`t[env], %Icons%\exitappskull.ico,,%is%
    Menu, tray, add, ; line -------------------------
    if (DevMode)
    {
        Menu, tray, add, Bug(De)`t[env], :BugTray
        Menu, tray, Icon, Bug(De)`t[env], %icons%\bug.ico,,%is%
        Menu, tray, add, ; line -------------------------
    }
if (A_IsAdmin)
{
    Menu, tray, add, Running As Admin!`t[env], dummy
    Menu, tray, Icon, Running As Admin!`t[env], %icons%\admin.ico,,%is%
    Menu, tray, disable, Running As Admin!`t[env]
}
    Menu, tray, add, ; line -------------------------
    
Menu, tray, UseErrorLevel, OFF
}
}

EditSoloIniENV()
{
    global iie
    If FileExist(iie)
    {
        run, %iie% "%soloini%"
    }
    else
        run, %soloini%
}
OpenScriptDirENV()
{
    run, %A_scriptdir%
}
ViewReadMeENV()
{
    global localreadme
    try run, %localreadme%
    catch
        try run, Notepad++.exe "%localreadme%"
    catch
        try run, Notepad.exe "%localreadme%"
}
ViewScribblesENV()
{
    global localscribbles
    run, %localscribbles%
}
RunLocalGithubLinkENV()
{
    local LocalGithubLink
    run, %LocalGithubLink%

}
SuspendHotkeysENV()
{
    Suspend
    Menu, tray, ToggleCheck, Suspend Hotkeys`t[env]
}
; PauseScriptENV()
; {
    ; Menu, tray, ToggleCheck, Pause Script`t[env]
    ; Pause
; }
Kill_CompiledScript()
{
    global compiled_name
    ; Run, taskkill /f /im %compiled_name%,, Hide
    PostMessage, 0x0111, 65307,,, ahk_exe %compiled_name%
    Menu, tray, delete, Kill Compiled App`t[env]
    ; buildtray()
    
}
CompileENV()
{
    global SourceScript, main, compilex
    run, %CompileX% "%SourceScript%"
    sleep 500
    exitapp
    ; SendToScript("Func|CompileX|" SourceScript "", main) ;; not working
    ; SendFuncToMain("func|CompileX|" SourceScript "")
    ; SendFuncToMain
}
editSourceENV()
{
    global sourcescript
    run, Notepad.exe %sourcescript%
}
; EditINIConfigENV() ;; moved to x:\ahk\xinc\x[msg].ahk


ReloadENV()
{
    Reload
}
Reload()
{
    Reload
}
quitENV()
{
    ExitApp
}
SwitchENV()
{
    global SourceScript, CompiledScript
    if (A_IsCompiled)
    {
        run, %SourceScript%
    }
    else
    {
        run, %CompiledScript%
    }
    sleep 800
    exitapp
}
ShowTrayMenu()
{
    Menu, tray, show
}

ListVars() {
ListVars
}

ListHotkeys() {
ListHotkeys
}

KeyHistory() {
KeyHistory
}

Listlines() {
Listlines
}

Menu, tray, Standard


; Copy this function into your script to use it.
HideTrayTip() {
    TrayTip  ; Attempt to hide it the normal way.
    if SubStr(A_OSVersion,1,3) = "10." {
        Menu Tray, NoIcon
        Sleep 200  ; It may be necessary to adjust this sleep.
        Menu Tray, Icon
    }
}

;; [MouseIsOver Globals] MouseIsOver() ;; Function
; Function to check if mouse is over the specified window
; MouseIsOver(WinTitle) ;; MouseIsOver() ;; Function // SHARED TODO
; {
; global control
; MouseGetPos,,, Win,Control
; return WinExist(WinTitle . " ahk_id " . Win . Control)
; }
global win
global control
listlines, off
MouseIsOver(WinTitle) ;; Function // SHARED todo mouseisover() 
{ 
    global control
    global Win
    MouseGetPos,,,Win,Control
    return WinExist(WinTitle . " ahk_id " . Win . Control)
}

listlines, on

badsound()
{
    If FileExist("X:\AHK\Icons\Sounds\OddHiss.wav")
        soundplay, X:\AHK\Icons\Sounds\OddHiss.wav
}

GetMenuIconSize()
{
    return DllCall("GetSystemMetrics", "Int", 50, "Int") ; SM_CYMENUCHECK = menu icon height
}


Paste(text)
{
    BackupClipboard()
    sleep 150
    clipboard := text
    clipwait,0.5
    Send, ^v
    sleep 400
    restoreclipboard()
    sleep 400
}

ShowMUM(menu)
{
    CoordMode, menu, Window
    MouseGetPos, mx, my
    mx := mx - 45
    my := my - 18
    Menu, %menu%, show, %mx%, %my%
}
; -[--- End of X:\AHK\xINC\x[env].ahk ---]-

; -[--- Start of X:\AHK\xINC\x[msg].ahk ---]-
;; see... x[msg](With Comments) - !!!!!!!!!!!!!!!!


global xdm := "X:\AHK\xDM.exe"

;; x[SendToMain].ahk
global labelname := ""
global stringtosend := ""
global StringReceived := ""
global CopyOfData := ""
global LabelCMD := atemp "\LabelCMD.txt"
global FuncCMD := atemp "\FuncCMD.txt"
DetectHiddenWindows, On
OnMessage(0x4A, "ReceiveMessage") ;; this is in autoexe ;; this need to be inside of DetectHiddenWindows says gpt:ai:

global MainScriptTitle := "xxx.ahk - AutoHotkey v1." ; X:\AHK\x.ahk ; X:\AHK\x.ini
global MainScript := "xxx.ahk - AutoHotkey v1."
; Global Main := AHK "\xxx.ahk - AutoHotkey v1." 
Global Main := ahk "\xxx.ahk" ;; changed 04-05-2026

DetectHiddenWindows, off

SendLabelToMain(text) {
        global msglog

    FileDelete, %LabelCMD%
    FileAppend, %text%, %LabelCMD%
    fileappend, `n%A_now% - Sent LabelCMD.txt TO Main via %A_thisfunc%(%text%) ¦ From= %A_ScriptFullPath%,%msglog%
}

SendFuncToMain(text) {
        global msglog

    FileDelete, %FuncCMD%
    FileAppend, %text%, %FuncCMD%
    fileappend, `n%A_now% - Sent FuncCMD=%FuncCMD% TO Main via %A_thisfunc%(%text%) ¦ From= %A_ScriptFullPath%`n,%msglog%
}

; ========================================
; FINAL VERSION: Use This Single Function
; ========================================
; usage = sendtoscript("GotoGuiContextMenu", "GoTo.ahk") ; !the script name is CaseSensitive!, sends label
SendToScript(ByRef StringToSend, ByRef TargetScript) {
    ; This function sends the specified string to the specified window and returns the reply.
    ; The reply is 1 if the target window processed the message, or 0 if it ignored it.
    global msglog

    if !InStr(TargetScript, "ahk_class")    ; Auto-append ahk_class if not present
        TargetScript .= " ahk_class AutoHotkey"
    
    ; Check if target window exists first
    Prev_DetectHiddenWindows := A_DetectHiddenWindows
    Prev_TitleMatchMode := A_TitleMatchMode
    DetectHiddenWindows, On
    SetTitleMatchMode, 2
    
    ; Check if window exists
    if !WinExist(TargetScript) {
        tip("The TargetScript = " TargetScript "`nIs Not Running\Not Found`nThe TargetScript Title is Case Sensitive! so Check your tyPos?", 5000)
        DetectHiddenWindows, %Prev_DetectHiddenWindows%
        SetTitleMatchMode, %Prev_TitleMatchMode%
        return 0
    }
    
    ; Set up the structure's memory area
    VarSetCapacity(CopyDataStruct, 3*A_PtrSize, 0)
    
    ; First set the structure's cbData member to the size of the string, including its zero terminator
    SizeInBytes := (StrLen(StringToSend) + 1) * (A_IsUnicode ? 2 : 1)
    NumPut(SizeInBytes, CopyDataStruct, A_PtrSize)  ; OS requires that this be done
    NumPut(&StringToSend, CopyDataStruct, 2*A_PtrSize)  ; Set lpData to point to the string itself
    
    TimeOutTime := 4000  ; Milliseconds to wait for response from receiver. Default is 5000
    
    ; Must use SendMessage not PostMessage
    SendMessage, 0x4A, 0, &CopyDataStruct,, %TargetScript%,,,, %TimeOutTime%  ; 0x4A is WM_COPYDATA
    
    ; Restore original settings for the caller
    DetectHiddenWindows, %Prev_DetectHiddenWindows%
    SetTitleMatchMode, %Prev_TitleMatchMode%
    FileAppend, `n%A_Now% - Sent Message via %A_thisfunc%(Params("StringToSend"`,"TargetScript")=(%StringToSend%`, %TargetScript%)) ¦FROM=%A_scriptfullpath% ¦TO=%TargetScript%`n, %msglog%
    ; Return SendMessage's reply back to our caller
    return ErrorLevel
}

SendToMain(ByRef StringToSend) {
    ; This function sends the specified string to the specified window and returns the reply.
    ; The reply is 1 if the target window processed the message, or 0 if it ignored it.

global Main, msglog, mainscript, MainScriptTitle
    ; if !InStr(TargetScript, "ahk_class")    ; Auto-append ahk_class if not present
        ; TargetScript .= " ahk_class AutoHotkey"
    ;; Window titles and text are case sensitive. Hidden windows are not detected unless DetectHiddenWindows has been turned on.
    ; Check if target window exists first
    ; Prev_DetectHiddenWindows := A_DetectHiddenWindows
    ; Prev_TitleMatchMode := A_TitleMatchMode
    DetectHiddenWindows, On
    SetTitleMatchMode, 2
    
    if !WinExist(Main) {    ; Check if window exists
        tip("The TargetScript = " Main "`nIs Not Running\Not Found`nThe TargetScript Title is Case Sensitive! so Check your tyPos?", 5000)
        ; DetectHiddenWindows, %Prev_DetectHiddenWindows%
    DetectHiddenWindows, Off
        ; SetTitleMatchMode, %Prev_TitleMatchMode%
        return 0
    }
    
    VarSetCapacity(CopyDataStruct, 3*A_PtrSize, 0)    ; Set up the structure's memory area
    
    ; First set the structure's cbData member to the size of the string, including its zero terminator
    SizeInBytes := (StrLen(StringToSend) + 1) * (A_IsUnicode ? 2 : 1)
    NumPut(SizeInBytes, CopyDataStruct, A_PtrSize)  ; OS requires that this be done
    NumPut(&StringToSend, CopyDataStruct, 2*A_PtrSize)  ; Set lpData to point to the string itself
    
    TimeOutTime := 4000  ; Milliseconds to wait for response from receiver. Default is 5000
    
    ; Must use SendMessage not PostMessage
    ; Sends a message to a window or control (SendMessage additionally waits for acknowledgement\a returned errorlevel msg).
    ; SendMessage, Msg [, wParam, lParam, Control, WinTitle, WinText, ExcludeTitle, ExcludeText, Timeout]
    SendMessage, 0x4A, 0, &CopyDataStruct,, %Main%,,,, %TimeOutTime%  ; 0x4A is WM_COPYDATA
    
    ; DetectHiddenWindows, %Prev_DetectHiddenWindows%    ; Restore original settings for the caller
    ; SetTitleMatchMode, %Prev_TitleMatchMode%
    FileAppend, `n%A_Now% - Sent Message via %A_thisfunc%(%StringToSend%) ¦FROM= %A_scriptname%¦TO= %Main%¦, %msglog%
DetectHiddenWindows, Off
    return ErrorLevel    ; Return SendMessage's reply back to our caller
}


;; x[ReceiveMessage].ahk
ReceiveMessage(wParam, lParam) {  ;; ReceiveMessage()
    global ahk, msglog

    Critical, On    ; CRITICAL: Set thread to interrupt-safe

    StringAddress := NumGet(lParam + 2*A_PtrSize)
    StringReceived := StrGet(StringAddress)
    
    parts := StrSplit(StringReceived, "|")
    
    FileAppend, `n%A_Now% - Message received in %A_scriptname% ¦ StringReceived=%StringReceived% ¦ via %A_ThisFunc%()`n, %msglog%
    ; FileAppend, %A_Now% - Content= %StringReceived%`n,   %msglog%

    if (parts.Length() = 1)    ; --- PRIORITY HANDLER ---
    {
        if IsLabel(StringReceived)
        {
            FileAppend, `n%A_Now% - Executing label= %StringReceived%¦in script %A_ScriptFullPath%`n,  %msglog%
            gosub %StringReceived%
            return true
        }
        else
        {

            return false            ;; Unknown single param – safely ignore
        }
    }

    cmd := parts[1]

    if (cmd = "msg")
        MsgBox, % parts[2]
    else if (cmd = "set")
        parts[2] := parts[3]
    else if (cmd = "toggle")
        parts[2] := !parts[2]
    else if (cmd = "run")
        Run, % parts[2]
    else if (cmd = "label" && IsLabel(parts[2]))
        Gosub % parts[2]
    ; else if (cmd = "func") ;; v1
    ; {
        ; fn := parts[2]
        ; if IsFunc(fn)
        ; {
            ; p1 := parts[3]
            ; p2 := parts[4]
            ; p3 := parts[5]

            ; if (p3 != "")
                ; %fn%(p1, p2, p3)
            ; else if (p2 != "")
                ; %fn%(p1, p2)
            ; else if (p1 != "")
                ; %fn%(p1)
            ; else
                ; %fn%()
        ; }
    ; }
    else if (cmd = "func") ;; v2 gpt add 12-22-2025, can now take more params, supposedly untested
    {
        fn := parts[2]

        params := []        ; Build params array
        for i, val in parts
            if (i > 2)
                params.Push(val)

        try
        {
            Func(fn).Call(params*)
        }
        catch e
        {
            ToolTip, Failed to call function:`n%fn% ;`n% e.Message
            SetTimer, RemoveToolTip, -3000
        }
    }
    else
        MsgBox, 16, Unknown Command, Unknown command:`n%StringReceived%`nin file = %A_LineFile% @@ %A_LineNumber%

    return true
} 






OpenIniSection(section)
{
    global inifile, iie
    if WinExist(" - iniEditor ahk_class AutoHotkeyGUI ahk_exe iniEditor.exe")
    {
        Winactivate
        iniwrite, %section%, %inifile%, iiEConfig, ASDToLoad         ; sleep 200
        SendToScript("SideLoadASDSection", "iniEditor.exe")
    }
    else
        run, %iie% /s "%section%" "%inifile%"
}
;; ==================================================
;; ==================================================
;; Moved from = %A_scriptdir%\xINC\aJump\aJump.ahk = 12/27/2025 @ 21:46 PM =
;; ==================================================
; usage LoadASDSection("Config_aJump")
LoadASDSection(section, File:="inifile")
{
    global inifile, iie, SectionDDL, 
    ; box(file)
    if !(file)
        File := inifile
        
    ; box(file A_nl inifile)
    
    if WinExist(" - iniEditor ahk_class AutoHotkeyGUI ahk_exe iniEditor.exe")
    {
        Winactivate
        iniwrite, %section%, %inifile%, inieditor_Config, ASDToLoad
        iniwrite, %file%, %inifile% inieditor_Config, ASDFileToLoad
        sleep 200
        SendToScript("SideLoadASDSection", "iniEditor.exe")
    }
    else
        run, %iie% /s "%section%" "%file%"
}
;; ==================================================
EditINIConfigENV()
{
    global sourcescript, A_ScriptStem, iie, inifile
    iieopen2 := "Config_" A_ScriptStem 
    findsection := "[Config_" A_ScriptStem "]"
    If FileExist(iie)
        LoadASDSection(iieopen2, inifile)
    else
        OpenFileToFoundText(inifile,findsection)
}


; -[--- End of X:\AHK\xINC\x[msg].ahk ---]-

; -[--- Start of X:\AHK\xINC\x[gui].ahk ---]-

; -[--- Start of X:\AHK\Lib\AddTooltip.ahk ---]-
;------------------------------
; source = https://www.autohotkey.com/boards/viewtopic.php?t=30079
; Function: AddTooltip v2.0
;
; Description:
;
;   Add/Update tooltips to GUI controls.
;
; Parameters:
;
;   p1 - Handle to a GUI control.  Alternatively, set to "Activate" to enable
;       the tooltip control, "AutoPopDelay" to set the autopop delay time,
;       "Deactivate" to disable the tooltip control, or "Title" to set the
;       tooltip title.
;
;   p2 - If p1 contains the handle to a GUI control, this parameter should
;       contain the tooltip text.  Ex: "My tooltip".  Set to null to delete the
;       tooltip attached to the control.  If p1="AutoPopDelay", set to the
;       desired autopop delay time, in seconds.  Ex: 10.  Note: The maximum
;       autopop delay time is ~32 seconds.  If p1="Title", set to the title of
;       the tooltip.  Ex: "Bob's Tooltips".  Set to null to remove the tooltip
;       title.  See the *Title & Icon* section for more information.
;
;   p3 - Tooltip icon.  See the *Title & Icon* section for more information.
;
; Returns:
;
;   The handle to the tooltip control.
;
; Requirements:
;
;   AutoHotkey v1.1+ (all versions).
;
; Title & Icon:
;
;   To set the tooltip title, set the p1 parameter to "Title" and the p2
;   parameter to the desired tooltip title.  Ex: AddTooltip("Title","Bob's
;   Tooltips"). To remove the tooltip title, set the p2 parameter to null.  Ex:
;   AddTooltip("Title","").
;
;   The p3 parameter determines the icon to be displayed along with the title,
;   if any.  If not specified or if set to 0, no icon is shown.  To show a
;   standard icon, specify one of the standard icon identifiers.  See the
;   function's static variables for a list of possible values.  Ex:
;   AddTooltip("Title","My Title",4).  To show a custom icon, specify a handle
;   to an image (bitmap, cursor, or icon).  When a custom icon is specified, a
;   copy of the icon is created by the tooltip window so if needed, the original
;   icon can be destroyed any time after the title and icon are set.
;
;   Setting a tooltip title may not produce a desirable result in many cases.
;   The title (and icon if specified) will be shown on every tooltip that is
;   added by this function.
;
; Remarks:
;
;   The tooltip control is enabled by default.  There is no need to "Activate"
;   the tooltip control unless it has been previously "Deactivated".
;
;   This function returns the handle to the tooltip control so that, if needed,
;   additional actions can be performed on the Tooltip control outside of this
;   function.  Once created, this function reuses the same tooltip control.
;   If the tooltip control is destroyed outside of this function, subsequent
;   calls to this function will fail.
;
; Credit and History:
;
;   Original author: Superfraggle
;   * Post: <http://www.autohotkey.com/board/topic/27670-add-tooltips-to-controls/>
;
;   Updated to support Unicode: art
;   * Post: <http://www.autohotkey.com/board/topic/27670-add-tooltips-to-controls/page-2#entry431059>
;
;   Additional: jballi.
;   Bug fixes.  Added support for x64.  Removed Modify parameter.  Added
;   additional functionality, constants, and documentation.
;
; v2.0
; Requirements:
; This and future versions of the function are designed to run on all versions of AutoHotkey v1.1+: ANSI, Unicode, and Unicode 64-bit.

; New Commands:
; (See the function documentation for more information)
; - Activate - Enable the tooltip control. Used to reverse the action of the Dectivate command.
; - AutoPopDelay - Set/Update the autopop delay time.
; - Dectivate - Disable the tooltip control. No tooltips created by this function are shown while the tooltip control is deactivated.
; - Title - Set or remove a tooltip title (requested by zcooler).

; Fixes/Updates/Enhancements:
; - Fixed a rare but serious bug that caused AutoHotkey to crash after a tooltip with more than 4K (2K in Unicode) of text was added. Thanks to zcooler for reporting the problem and to qwerty12 for identifying the fix.

;-------------------------------------------------------------------------------
; #warn, off

AddTooltip(p1,p2:="",p3="")
{
    ; listlines, off
    Static hTT  ; := "" ;; xadd this was casing errors, but this is still not right
     ; Global hTT := ""

          ;-- Misc. constants
          ,CW_USEDEFAULT:=0x80000000
          ,HWND_DESKTOP :=0

          ;-- Tooltip delay time constants
          ,TTDT_AUTOPOP:=2
                ;-- Set the amount of time a tooltip window remains visible if
                ;   the pointer is stationary within a tool's bounding
                ;   rectangle.

          ;-- Tooltip styles
          ,TTS_ALWAYSTIP:=0x1
                ;-- Indicates that the tooltip control appears when the cursor
                ;   is on a tool, even if the tooltip control's owner window is
                ;   inactive.  Without this style, the tooltip appears only when
                ;   the tool's owner window is active.

          ,TTS_NOPREFIX:=0x2
                ;-- Prevents the system from stripping ampersand characters from
                ;   a string or terminating a string at a tab character.
                ;   Without this style, the system automatically strips
                ;   ampersand characters and terminates a string at the first
                ;   tab character.  This allows an application to use the same
                ;   string as both a menu item and as text in a tooltip control.

          ;-- TOOLINFO uFlags
          ,TTF_IDISHWND:=0x1
                ;-- Indicates that the uId member is the window handle to the
                ;   tool.  If this flag is not set, uId is the identifier of the
                ;   tool.

          ,TTF_SUBCLASS:=0x10
                ;-- Indicates that the tooltip control should subclass the
                ;   window for the tool in order to intercept messages, such
                ;   as WM_MOUSEMOVE.  If this flag is not used, use the
                ;   TTM_RELAYEVENT message to forward messages to the tooltip
                ;   control.  For a list of messages that a tooltip control
                ;   processes, see TTM_RELAYEVENT.

          ;-- Tooltip icons
          ,TTI_NONE         :=0
          ,TTI_INFO         :=1
          ,TTI_WARNING      :=2
          ,TTI_ERROR        :=3
          ,TTI_INFO_LARGE   :=4
          ,TTI_WARNING_LARGE:=5
          ,TTI_ERROR_LARGE  :=6

          ;-- Extended styles
          ,WS_EX_TOPMOST:=0x8

          ;-- Messages
          ,TTM_ACTIVATE      :=0x401                    ;-- WM_USER + 1
          ,TTM_ADDTOOLA      :=0x404                    ;-- WM_USER + 4
          ,TTM_ADDTOOLW      :=0x432                    ;-- WM_USER + 50
          ,TTM_DELTOOLA      :=0x405                    ;-- WM_USER + 5
          ,TTM_DELTOOLW      :=0x433                    ;-- WM_USER + 51
          ,TTM_GETTOOLINFOA  :=0x408                    ;-- WM_USER + 8
          ,TTM_GETTOOLINFOW  :=0x435                    ;-- WM_USER + 53
          ,TTM_SETDELAYTIME  :=0x403                    ;-- WM_USER + 3
          ,TTM_SETMAXTIPWIDTH:=0x418                    ;-- WM_USER + 24
          ,TTM_SETTITLEA     :=0x420                    ;-- WM_USER + 32
          ,TTM_SETTITLEW     :=0x421                    ;-- WM_USER + 33
          ,TTM_UPDATETIPTEXTA:=0x40C                    ;-- WM_USER + 12
          ,TTM_UPDATETIPTEXTW:=0x439                    ;-- WM_USER + 57

    ;-- Save/Set DetectHiddenWindows
    l_DetectHiddenWindows:=A_DetectHiddenWindows
    DetectHiddenWindows On

    ;-- Tooltip control exists?
    if not hTT
        {
        ;-- Create Tooltip window
        hTT:=DllCall("CreateWindowEx"
            ,"UInt",WS_EX_TOPMOST                       ;-- dwExStyle
            ,"Str","TOOLTIPS_CLASS32"                   ;-- lpClassName
            ,"Ptr",0                                    ;-- lpWindowName
            ,"UInt",TTS_ALWAYSTIP|TTS_NOPREFIX          ;-- dwStyle
            ,"UInt",CW_USEDEFAULT                       ;-- x
            ,"UInt",CW_USEDEFAULT                       ;-- y
            ,"UInt",CW_USEDEFAULT                       ;-- nWidth
            ,"UInt",CW_USEDEFAULT                       ;-- nHeight
            ,"Ptr",HWND_DESKTOP                         ;-- hWndParent
            ,"Ptr",0                                    ;-- hMenu
            ,"Ptr",0                                    ;-- hInstance
            ,"Ptr",0                                    ;-- lpParam
            ,"Ptr")                                     ;-- Return type

        ;-- Disable visual style
        ;   Note: Uncomment the following to disable the visual style, i.e.
        ;   remove the window theme, from the tooltip control.  Since this
        ;   function only uses one tooltip control, all tooltips created by this
        ;   function will be affected.
; DllCall("uxtheme\SetWindowTheme","Ptr",hTT,"Ptr",0,"UIntP",0)

        ;-- Set the maximum width for the tooltip window
        ;   Note: This message makes multi-line tooltips possible
        ; SendMessage TTM_SETMAXTIPWIDTH,0,A_ScreenWidth,,ahk_id %hTT% ;; og
		SendMessage TTM_SETMAXTIPWIDTH,0,A_ScreenWidth*96//A_ScreenDPI,,ahk_id %hTT%  ; <--- was A_ScreenWidth
        }

    ;-- Other commands
    if p1 is not Integer
        {
        if (p1="Activate")
            SendMessage TTM_ACTIVATE,True,0,,ahk_id %hTT%

        if (p1="Deactivate")
            SendMessage TTM_ACTIVATE,False,0,,ahk_id %hTT%

        if (InStr(p1,"AutoPop")=1)  ;-- Starts with "AutoPop"
            SendMessage TTM_SETDELAYTIME,TTDT_AUTOPOP,p2*1000,,ahk_id %hTT%
        
        if (p1="Title")
            {
            ;-- If needed, truncate the title
            if (StrLen(p2)>99)
                p2:=SubStr(p2,1,99)

            ;-- Icon
            if p3 is not Integer
                p3:=TTI_NONE

            ;-- Set title
            SendMessage A_IsUnicode ? TTM_SETTITLEW:TTM_SETTITLEA,p3,&p2,,ahk_id %hTT%
            }

        ;-- Restore DetectHiddenWindows
        DetectHiddenWindows %l_DetectHiddenWindows%
    
        ;-- Return the handle to the tooltip control
        Return hTT
        }

    ;-- Create/Populate the TOOLINFO structure
    uFlags:=TTF_IDISHWND|TTF_SUBCLASS
    cbSize:=VarSetCapacity(TOOLINFO,(A_PtrSize=8) ? 64:44,0)
    NumPut(cbSize,      TOOLINFO,0,"UInt")              ;-- cbSize
    NumPut(uFlags,      TOOLINFO,4,"UInt")              ;-- uFlags
    NumPut(HWND_DESKTOP,TOOLINFO,8,"Ptr")               ;-- hwnd
    NumPut(p1,          TOOLINFO,(A_PtrSize=8) ? 16:12,"Ptr")
        ;-- uId

    ;-- Check to see if tool has already been registered for the control
    SendMessage
        ,A_IsUnicode ? TTM_GETTOOLINFOW:TTM_GETTOOLINFOA
        ,0
        ,&TOOLINFO
        ,,ahk_id %hTT%

    l_RegisteredTool:=ErrorLevel

    ;-- Update the TOOLTIP structure
    NumPut(&p2,TOOLINFO,(A_PtrSize=8) ? 48:36,"Ptr")
        ;-- lpszText

    ;-- Add, Update, or Delete tool
    if l_RegisteredTool
        {
        if StrLen(p2)
            SendMessage
                ,A_IsUnicode ? TTM_UPDATETIPTEXTW:TTM_UPDATETIPTEXTA
                ,0
                ,&TOOLINFO
                ,,ahk_id %hTT%
         else
            SendMessage
                ,A_IsUnicode ? TTM_DELTOOLW:TTM_DELTOOLA
                ,0
                ,&TOOLINFO
                ,,ahk_id %hTT%
        }
    else
        if StrLen(p2)
            SendMessage
                ,A_IsUnicode ? TTM_ADDTOOLW:TTM_ADDTOOLA
                ,0
                ,&TOOLINFO
                ,,ahk_id %hTT%

    ;-- Restore DetectHiddenWindows
    DetectHiddenWindows %l_DetectHiddenWindows%

    ;-- Return the handle to the tooltip control
    Return hTT
    ; listlines, on
    }


; -[--- End of X:\AHK\Lib\AddTooltip.ahk ---]-

; -[--- Start of X:\AHK\Lib\GuiButtonIcon.ahk ---]-
;{ GuiButtonIcon

;------------------------------------------------
; FUNCTION to Assign an Icon to a Gui Button
; Fanatic Guru ; 2014 05 31 ; Version 2.0
; Method:
;   GuiButtonIcon(Handle, File, Options)
;
;   Parameters:
;   1) {Handle} 	HWND handle of Gui button
;   2) {File} 		File containing icon image
;   3) {Index} 		Index of icon in file
;						Optional: Default = 1
;   4) {Options}	Single letter flag followed by a number with multiple options delimited by a space
;						W = Width of Icon (default = 16)
;						H = Height of Icon (default = 16)
;						S = Size of Icon, Makes Width and Height both equal to Size
;						L = Left Margin
;						T = Top Margin
;						R = Right Margin
;						B = Botton Margin
;						A = Alignment (0 = left, 1 = right, 2 = top, 3 = bottom, 4 = center; default = 4)
;
; Return:
;   1 = icon found, 0 = icon not found
;
; Example:
; Gui, Add, Button, w70 h38 hwndIcon, Save
; GuiButtonIcon(Icon, "shell32.dll", 259, "s30 a1 r2")
;   GuiButtonIcon(Handle, File, Options)
; Gui, Show

;; og Func here, was trowing an error in \QuickX.ahk, claude made a change, (next block below), make it work AQX, but now its breaking on other apps. can't have it.
GuiButtonIcon(Handle, File, Index := 1, Options := "")
{
    listlines, off
	RegExMatch(Options, "i)w\K\d+", W), (W="") ? W := 16 :
	RegExMatch(Options, "i)h\K\d+", H), (H="") ? H := 16 :
	RegExMatch(Options, "i)s\K\d+", S), S ? W := H := S :
	RegExMatch(Options, "i)l\K\d+", L), (L="") ? L := 0 :
	RegExMatch(Options, "i)t\K\d+", T), (T="") ? T := 0 :
	RegExMatch(Options, "i)r\K\d+", R), (R="") ? R := 0 :
	RegExMatch(Options, "i)b\K\d+", B), (B="") ? B := 0 :
	RegExMatch(Options, "i)a\K\d+", A), (A="") ? A := 4 :
	Psz := A_PtrSize = "" ? 4 : A_PtrSize, DW := "UInt", Ptr := A_PtrSize = "" ? DW : "Ptr"
	VarSetCapacity( button_il, 20 + Psz, 0 )
	NumPut( normal_il := DllCall( "ImageList_Create", DW, W, DW, H, DW, 0x21, DW, 1, DW, 1 ), button_il, 0, Ptr )	; Width & Height
	NumPut( L, button_il, 0 + Psz, DW )		; Left Margin
	NumPut( T, button_il, 4 + Psz, DW )		; Top Margin
	NumPut( R, button_il, 8 + Psz, DW )		; Right Margin
	NumPut( B, button_il, 12 + Psz, DW )	; Bottom Margin	
	NumPut( A, button_il, 16 + Psz, DW )	; Alignment
	SendMessage, BCM_SETIMAGELIST := 5634, 0, &button_il,, AHK_ID %Handle%
	return IL_Add( normal_il, File, Index )
    listlines, On
}


; -[--- End of X:\AHK\Lib\GuiButtonIcon.ahk ---]-

; -[--- Start of X:\AHK\Lib\AutoXYWH.ahk ---]-




; =================================================================================
; Function: AutoXYWH
;   Move and resize control automatically when GUI resizes.
; Parameters:
;   DimSize - Can be one or more of x/y/w/h  optional followed by a fraction
;             add a '*' to DimSize to 'MoveDraw' the controls rather then just 'Move', this is recommended for Groupboxes
;             add a 't' to DimSize to tell AutoXYWH that the controls in cList are on/in a tab3 control
;   cList   - variadic list of ControlIDs
;             ControlID can be a control HWND, associated variable name, ClassNN or displayed text.
;             The later (displayed text) is possible but not recommend since not very reliable 
; Examples:
;   AutoXYWH("xy", "Btn1", "Btn2")
;   AutoXYWH("w0.5 h 0.75", hEdit, "displayed text", "vLabel", "Button1")
;   AutoXYWH("*w0.5 h 0.75", hGroupbox1, "GrbChoices")
;   AutoXYWH("t x h0.5", "Btn1")
; ---------------------------------------------------------------------------------
; Version: 2020-5-20 / small code improvements (toralf)
;          2018-1-31 / added a line to prevent warnings (pramach)
;          2018-1-13 / added t option for controls on Tab3 (Alguimist)
;          2015-5-29 / added 'reset' option (tmplinshi)
;          2014-7-03 / mod by toralf
;          2014-1-02 / initial version tmplinshi
; requires AHK version : 1.1.13.01+    due to SprSplit()
; ================================================================================= 

AutoXYWH(DimSize, cList*){   ;https://www.autohotkey.com/boards/viewtopic.php?t=1079
  Static cInfo := {}

  If (DimSize = "reset")
    Return cInfo := {}

  For i, ctrl in cList {
    ctrlID := A_Gui ":" ctrl
    If !cInfo.hasKey(ctrlID) {
      ix := iy := iw := ih := 0	
      GuiControlGet i, %A_Gui%: Pos, %ctrl%
      MMD := InStr(DimSize, "*") ? "MoveDraw" : "Move"
      fx := fy := fw := fh := 0
      For i, dim in (a := StrSplit(RegExReplace(DimSize, "i)[^xywh]"))) 
        If !RegExMatch(DimSize, "i)" . dim . "\s*\K[\d.-]+", f%dim%)
          f%dim% := 1

      If (InStr(DimSize, "t")) {
        GuiControlGet hWnd, %A_Gui%: hWnd, %ctrl%
        hParentWnd := DllCall("GetParent", "Ptr", hWnd, "Ptr")
        VarSetCapacity(RECT, 16, 0)
        DllCall("GetWindowRect", "Ptr", hParentWnd, "Ptr", &RECT)
        DllCall("MapWindowPoints", "Ptr", 0, "Ptr", DllCall("GetParent", "Ptr", hParentWnd, "Ptr"), "Ptr", &RECT, "UInt", 1)
        ix := ix - NumGet(RECT, 0, "Int")
        iy := iy - NumGet(RECT, 4, "Int")
      }

      cInfo[ctrlID] := {x:ix, fx:fx, y:iy, fy:fy, w:iw, fw:fw, h:ih, fh:fh, gw:A_GuiWidth, gh:A_GuiHeight, a:a, m:MMD}
    } Else {
      dgx := dgw := A_GuiWidth - cInfo[ctrlID].gw, dgy := dgh := A_GuiHeight - cInfo[ctrlID].gh
      Options := ""
      For i, dim in cInfo[ctrlID]["a"]
        Options .= dim (dg%dim% * cInfo[ctrlID]["f" . dim] + cInfo[ctrlID][dim]) A_Space
      GuiControl, % A_Gui ":" cInfo[ctrlID].m, % ctrl, % Options
} } }

















/*
; =================================================================================
; Function: AutoXYWH
;   Move and resize control automatically when GUI resizes.
; Parameters:
;   DimSize - Can be one or more of x/y/w/h  optional followed by a fraction
;             add a '*' to DimSize to 'MoveDraw' the controls rather then just 'Move', this is recommended for Groupboxes
;   cList   - variadic list of ControlIDs
;             ControlID can be a control HWND, associated variable name, ClassNN or displayed text.
;             The later (displayed text) is possible but not recommend since not very reliable 
; Examples:
;   AutoXYWH("xy", "Btn1", "Btn2")
;   AutoXYWH("w0.5 h 0.75", hEdit, "displayed text", "vLabel", "Button1")
;   AutoXYWH("*w0.5 h 0.75", hGroupbox1, "GrbChoices")
; ---------------------------------------------------------------------------------
; Version: 2015-5-29 / Added 'reset' option (by tmplinshi)
;          2014-7-03 / toralf
;          2014-1-2  / tmplinshi
; requires AHK version : 1.1.13.01+
; =================================================================================
AutoXYWH(DimSize, cList*){       ; http://ahkscript.org/boards/viewtopic.php?t=1079
  static cInfo := {}
 
  If (DimSize = "reset")
    Return cInfo := {}
 
  For i, ctrl in cList {
    ctrlID := A_Gui ":" ctrl
    If ( cInfo[ctrlID].x = "" ){
        GuiControlGet, i, %A_Gui%:Pos, %ctrl%
        MMD := InStr(DimSize, "*") ? "MoveDraw" : "Move"
        fx := fy := fw := fh := 0
        For i, dim in (a := StrSplit(RegExReplace(DimSize, "i)[^xywh]")))
            If !RegExMatch(DimSize, "i)" dim "\s*\K[\d.-]+", f%dim%)
              f%dim% := 1
        cInfo[ctrlID] := { x:ix, fx:fx, y:iy, fy:fy, w:iw, fw:fw, h:ih, fh:fh, gw:A_GuiWidth, gh:A_GuiHeight, a:a , m:MMD}
    }Else If ( cInfo[ctrlID].a.1) {
        dgx := dgw := A_GuiWidth  - cInfo[ctrlID].gw  , dgy := dgh := A_GuiHeight - cInfo[ctrlID].gh
        For i, dim in cInfo[ctrlID]["a"]
            Options .= dim (dg%dim% * cInfo[ctrlID]["f" dim] + cInfo[ctrlID][dim]) A_Space
        GuiControl, % A_Gui ":" cInfo[ctrlID].m , % ctrl, % Options
} } }

*/
; #Include, AutoXYWH.ahk

; Gui, +Resize
; Gui, Add, Edit, ve1 w150 h100
; Gui, Add, Button, vb1 gResize, Resize
; Gui, add, button, xm vb2 gdummy, dummy b2
; Gui, Show
; return

; Resize:
	; GuiControl, Move, e1, h50
	; AutoXYWH("reset") ; Needs to reset if you changed the Control size manually.
; return
 
; GuiSize:
	; If (A_EventInfo = 1) ; The window has been minimized.
		; Return
	; AutoXYWH("wh", "e1")
	; AutoXYWH("y", "b1")
    ; autoxywh("xy", "b2")
; return

; dummy:
; return


; -[--- End of X:\AHK\Lib\AutoXYWH.ahk ---]-


contextcolor() ;0=Default ;1=AllowDark ;2=ForceDark ;3=ForceLight ;4=Max
contextcolor(color:=2)
	{
        static uxtheme := DllCall("GetModuleHandle", "str", "uxtheme", "ptr")
        static SetPreferredAppMode := DllCall("GetProcAddress", "ptr", uxtheme, "ptr", 135, "ptr")
        static FlushMenuThemes := DllCall("GetProcAddress", "ptr", uxtheme, "ptr", 136, "ptr")
        DllCall(SetPreferredAppMode, "int", color)
        DllCall(FlushMenuThemes)
	}

OnMessage(0x0201, "WM_LBUTTONDOWNdrag")    ;;∙------∙Gui Drag Pt 1. 

WM_LBUTTONDOWNdrag() {  ;;∙======∙Gui Drag Pt 2
; Get the control class under mouse
    MouseGetPos,,, Win, Control
    

    ; if InStr(Control, "Edit")    ; Don't drag if clicking in an Edit control
        ; return
    

    ; if InStr(Control, "SysListView")    ; Don't drag if clicking in a ListView
        ; return
    
    ; Don't drag if clicking a Button
    if InStr(Control, "Button")
        return
    
    ; Only drag from the GUI background or specific safe areas
    PostMessage, 0x00A1, 2, 0
}

; WM_LBUTTONDOWNdrag(wParam, lParam, msg, hwnd) {
    ; MouseGetPos,,, Win, Control
    ; if (Control = "")    ; Only drag if NOT clicking on any control (background only)
        ; PostMessage, 0x00A1, 2, 0
; }

OnMessage(0x0232, "WM_EXITSIZEMOVE")      ; stop drag/move = save pos ; fires when move/resize ends
; WM_EXITSIZEMOVE() { } ;; function can be used were need in sricpts but not in this fill, to many other script are using it

;; ==================================================
;; Moved from = %A_scriptdir%\xINC\x[set].ahk = 12/18/2025 @ 23:26 PM =
;; ==================================================
;; usage ; SetWindowIcon(hrunner, cmdboxicon) ;; this set window icon has to stay below gui  show xnote
SetWindowIcon(hGui, IconPath)
{
    hIcon := DllCall("LoadImage", "Ptr", 0, "Str", IconPath, "UInt", 1, "Int", 0, "Int", 0, "UInt", 0x10)
    SendMessage, 0x80, 1, hIcon,, ahk_id %hGui% ; WM_SETICON (1 = ICON_BIG)
    ; SendMessage 0x0080, 1, hIcon
    SendMessage, 0x80, 0, hIcon,, ahk_id %hGui% ; WM_SETICON (0 = ICON_SMALL)
}

; Window Appearance ;; from ahk.chm
; For its icon, a GUI window uses the tray icon that was in effect at the time the window was created. Thus, to have a different icon, change the tray icon before creating the window. For example: Menu, Tray, Icon, MyIcon.ico. It is also possible to have a different large icon for a window than its small icon (the large icon is displayed in the alt-tab task switcher). This can be done via LoadPicture() and SendMessage; for example:

; iconsize := 32  ; Ideal size for alt-tab varies between systems and OS versions.
; hIcon := LoadPicture("My Icon.ico", "Icon1 w" iconsize " h" iconsize, imgtype)
; Gui +LastFound
; SendMessage 0x0080, 1, hIcon  ; 0x0080 is WM_SETICON; and 1 means ICON_BIG (vs. 0 for ICON_SMALL).
; Gui Show


/*
SetWindowIcon(hGui, IconPath)
; The issue is you're loading with default size (0x10 = LR_LOADFROMFILE). You need to specify the exact icon sizes Windows uses for title bars:
{
    ; Get system metrics for exact sizes Windows wants
    SM_CXSMICON := 49
    SM_CYSMICON := 50
    SM_CXICON := 11
    SM_CYICON := 12
    
    smallW := DllCall("GetSystemMetrics", "Int", SM_CXSMICON)
    smallH := DllCall("GetSystemMetrics", "Int", SM_CYSMICON)
    largeW := DllCall("GetSystemMetrics", "Int", SM_CXICON)
    largeH := DllCall("GetSystemMetrics", "Int", SM_CYICON)
    
    ; Load with exact system sizes
    hIconSmall := DllCall("LoadImage", "Ptr", 0, "Str", IconPath, "UInt", 1
        , "Int", smallW, "Int", smallH, "UInt", 0x10, "Ptr")
    hIconLarge := DllCall("LoadImage", "Ptr", 0, "Str", IconPath, "UInt", 1
        , "Int", largeW, "Int", largeH, "UInt", 0x10, "Ptr")
    
    SendMessage, 0x80, 0, hIconSmall,, ahk_id %hGui%
    SendMessage, 0x80, 1, hIconLarge,, ahk_id %hGui%
}
*/

;; ==================================================
; Or if you wa_nt a reusable function:ahk
LV_AutoSizeCol(col := 0) {
    if (col = 0)
        Loop % LV_GetCount("Column")
            LV_ModifyCol(A_Index, "AutoHdr")
    else
        LV_ModifyCol(col, "AutoHdr")
; Then call it anywhere with: ahk
; LV_AutoSize()    ; all columns
; LV_AutoSize(1)   ; column 1 only
; LV_AutoSize(2)   ; column 2 only
}
;; ==================================================


;*************************  DARKMODE is set as the DEFAULT.
;*************************  DARKMODE TOGGLE.

; if you want LIGHT MODE as the Default, change it below....
	 ; 0=Default  1=AllowDark  2=ForceDark  3=ForceLight  4=Max
	 ; DarkMenu(Dark:=3) ; Sets to ForceLight
	 ; DarkMenu(Dark:=2) ; Sets to ForceDark

DarkMenu(Dark:=2) ;<<==<-CHANGE DEFAULT HERE. Only the # has to be changed.
{
    static uxtheme := DllCall("GetModuleHandle", "str", "uxtheme", "ptr")
    static SetPreferredAppMode := DllCall("GetProcAddress", "ptr", uxtheme, "ptr", 135, "ptr")
    static FlushMenuThemes := DllCall("GetProcAddress", "ptr", uxtheme, "ptr", 136, "ptr")
    DllCall(SetPreferredAppMode, "int", Dark)
    DllCall(FlushMenuThemes) 	;https://stackoverflow.com/a/58547831/894589
}
; DarkMenu()  ;toggle command ;moved to 

; darkmode = true  ; Do not change or delete this line. It will break the toggle function. Even if you change the default below, that overrides this.
; darkmode = False  ; Do not change or delete this line. It will break the toggle function. Even if you change the default below, that overrides this.
; DarkMenu(dark:="")  ;;; this is for fucking round
; {

; }
; DarkMode := true ; set initial mode to light, in 
;;; dark mode toggles are contained in the x[globals].ahk
;;; dark mode menu color, 2B2B2B

;===========================================================================
;===========================================================================
;============

; DarkModeButtons() ; ai:Slop
; {
    ; WinGet, ctrlList, ControlList, A
    ; Loop, Parse, ctrlList, `n
    ; {
        ; GuiControlGet, ctrlType, Name, %A_LoopField%
        ; if InStr(ctrlType, "Button")
        ; {
            ; GuiControlGet, hwnd, Hwnd, %A_LoopField%
            ; DllCall("uxtheme\SetWindowTheme", "ptr", hwnd, "str", "DarkMode_Explorer", "ptr", 0)
        ; }
    ; }
; }

; -[--- End of X:\AHK\xINC\x[gui].ahk ---]-





;===========================================================================
;===========================================================================
;===========================================================================

; if !Fileexist(Icon)
	; {
	;;;; gosub checkinstalledicons
	
	; }

;--------------------------------------------------

;--------------------------------------------------

; DarkMenu()
; DarkMenu(Dark:=2)
; { ;<<==<-CHANGE DEFAULT HERE. Only the # has to be changed. ;    DarkMenu(DarkMenu:="") { ;<<==<-CHANGE DEFAULT HERE. Only the # has to be changed.
    ; static uxtheme := DllCall("GetModuleHandle", "str", "uxtheme", "ptr")
    ; static SetPreferredAppMode := DllCall("GetProcAddress", "ptr", uxtheme, "ptr", 135, "ptr")
    ; static FlushMenuThemes := DllCall("GetProcAddress", "ptr", uxtheme, "ptr", 136, "ptr")
    ; DllCall(SetPreferredAppMode, "int", Dark)
    ; DllCall(FlushMenuThemes) ;    https://stackoverflow.com/a/58547831/894589
; }
darkmode = true  ; Do not change or delete this line. It will break the toggle function. Even if you change the default below, that overrides this.

;--------------------------------------------------
; OnMessage(0x0201, "WM_LBUTTONDOWNdrag")    ;;∙------∙Gui Drag Pt 1.
;;∙======∙Gui Drag Pt 2∙==========================================∙
; WM_LBUTTONDOWNdrag() {
   ; PostMessage, 0x00A1, 2, 0
; }
; OnMessage(0x0232, "WM_EXITSIZEMOVE")      ; stop drag/move = save pos in env
WM_EXITSIZEMOVE() {
RememberWinPos() 
}
;; global settings
SetWorkingDir,%A_scriptdir%

SetBatchLines -1
#MaxThreads 255
AutoTrim On

; add to your script init / auto-execute section
VarSetCapacity(gdipsi, 16, 0)
NumPut(1, gdipsi, 0, "uint")
DllCall("gdiplus\GdiplusStartup", "ptr*", gdipToken, "ptr", &gdipsi, "ptr", 0)


;; all gui vars #todo
global folderpath
global Iconfile
global iconpath
global iconext
Global noneicowarning
Global IconResource
global applytoallsubs
Global IconIndex
global ChangeNumber
global infotip
global allowTTB
global allow
global OFM
global loadbutton
global icondir
global font
global oldinfotip
global FolderPathOnClose
global IconPathOnClose
global RememberHistory
global delini
global forcewindownsreload := 0
global CopyIcoToDest := 0
global OnStartUp_AutoLoadLastFolder := 0 ; 
global History_NumberOfItemsToRemember := 30
global allowDELINI := 0
Global HideLocalIco := 0
Global CopyIcoToDest := 0

global ShowInfoTipExtras := 1
global LiveFolderMaxFilesCount := 3000
global RememberWindowPos := 1
desktopIni := folderpath "\desktop.ini"
global desktopIni
global is := 24
; existinginimsg := "desktop.ini content.`n`nIf a folder has an existing desktop.ini file it will be displayed here.`n`n#Todo, Add the ability to edit a d.ini directly to this edit. on var.."
; existinginimsg := "desktop.ini content.`n`nIf a folder has an existing desktop.ini file it will be displayed here."
global existinginimsg := "If a folder has an existing desktop.ini file it's content will be displayed here."
folderinfotipmsg := "Add Optional Folder Info Tip"
ScriptName := "Change Folder Icon"
global ScriptName

Global 1stRelease := "v.2025.03.10"
; if !(A_IsCompiled)
	; Fileversion := LastUpdate
; msgbox %fileversion%
global LastUpdate := "v.2026.03.24"

global Description := "Change Folder Icons from a Quick and Simple GUI"
global githuburl := "https://github.com/indigofairyx/Change-Folder-Icon"
global Startlink := A_StartMenu "\Programs\" ScriptName ".lnk"
global startlink
global StartLinkCreated
Icons = %A_ScriptDir%\Icons
Global Icons
global x := 500
global y := 500
; msgbox, icons=%icons%`nworking dir =%A_workingdir%
; if !FileExist(icons)
	; {
	; }

;-------------------------------------------------- 
pinFF=%A_ScriptDir%\Icons\pinoff.ico
pinNN=%A_ScriptDir%\Icons\pinon.ico
global pinFF, pinNN, pinstartpic

; Global pinstartpic := 1  ; Variable gui pin state
	
; INIReadGlobal_Hotkeys()
; INIReadHotkeys()
; INIReadPrograms()
; INIReadSettings()
; INIReadHotkeySection(sectionName)
; INIReadSection(sectionName)

; if (A_OSVersion >= "10.0.22000")
    ; { ;; if Win 11 	MsgBox, This is likely Windows 11
	; }
; box(inifile)


INIReadSection("Settings")


    
; iniread, iconerror, %inifile%, Settings, IconError
global iconerror
; if (iconerror = "" || "ERROR" || "0")
; if (iconerror = "" || "ERROR" || "0" || !FileExist(iconerror))
	; iconerror = %icons%\iconerror.ico
if FileExist(iconerror)
    iconerror := iconerror
else
    iconerror := icons "\iconerror.ico"

; Box(iconerror, 4)   ; run, %iconerror%


if (A_OSVersion = "10.0.22000" or A_OSVersion >= "10.0.22000")
{ ;; if Win 11 	MsgBox, This is likely Windows 11
    if FileExist("C:\Program Files\WindowsApps\Microsoft.Paint_11.2302.20.0_x64__8wekyb3d8bbwe\PaintApp\mspaint.exe")
        MSPaint = C:\Program Files\WindowsApps\Microsoft.Paint_11.2302.20.0_x64__8wekyb3d8bbwe\PaintApp\mspaint.exe
    else
        MSPaint = C:\Windows\System32\mspaint.exe
}
else
{ ;; if Win 10	MsgBox, Probably Windows 10 or earlier
    MSPaint = C:\Windows\System32\mspaint.exe
}





; if (RememberWindowPos)
	; OnExit("RememberWinPos") ;; this doesn't need to be remembered now as the new function saves it auto-maticlly after bing moved. 03-29-2026
OnExit("Exiter")
Exiter()
{
    global gdipToken, tempico, RememberHistory, OnStartUp_AutoLoadLastFolder
    Menu, tray, NoIcon ;; attempt to clear the old icon from the system tray
    FileDelete, %tempico% ;; delete temp file from previewing icons
    FileDelete, %A_Temp%\~iconpreview.ico
    FileDelete, %A_Temp%\~iconpreview.png
    FileDelete, %A_ScriptDir%\IconIndex
    if (OnStartUp_AutoLoadLastFolder) || (RememberHistory)
        RememberLastPaths()
    DllCall("gdiplus\GdiplusShutdown", "ptr", gdipToken) ;; clear allocated memory from previewing icons
}
global IS := MenuIconSize

if !FileExist(IconLibrary)
	IconLibrary = C:\Users\%A_UserName%\Pictures

if (HideTooltips)
	AddTooltip("Deactivate")
else
	AddTooltip("Activate")
	
if (ShowAHKErrorWarnings)
{
    #warn
}
else
{
    Menu, Tray, UseErrorLevel, On
    #warn, all, Off
    #warn, useenv, off
}

iniread, showhotkeymenulabel, %inifile%, Hotkeys, showhotkeymenu
; showhotkeymenu= F1 | Show the hotkey menu
showhotkeymenu := RegExReplace(showhotkeymenulabel, "\|.*", "")
; msgbox, shmL: %showhotkeymenulabel%`n`nshm: %showhotkeymenu%
SetTitleMatchMode, 2
menu, k, add,
menu, k, deleteall
menu, k, add, Quick Actions && Hotkeys Menu`t%Showhotkeymenu%, Showhotkeymenu
menu, k, icon, Quick Actions && Hotkeys Menu`t%Showhotkeymenu%, %icons%\hotkeys.ico,,28
menu, k, default, Quick Actions && Hotkeys Menu`t%Showhotkeymenu%
menu, k, add, ; line -------------------------
Hotkey, IfWinActive, - Change Folder .Ico - ahk_class AutoHotkeyGUI
; INIReadHotkeys()
INIReadHotkeySection("Hotkeys")
hotkey, IfWinActive
; INIReadGlobal_Hotkeys()
INIReadHotkeySection("Global_Hotkeys")
; ReadableHotkey := ConvertAHKSymbolToWords(HotkeyValue)
menu, k, add, ; line -------------------------
menu, k, add, General About \ Help`t%AboutMessage%, AboutMessage
menu, k, icon, General About \ Help`t%AboutMessage%, %icons%\about.ico,,
menu, k, add, Hotkey Help, Hotkeyhelp
menu, k, icon, Hotkey Help, %icons%\about.ico
menu, k, add, Edit Settings File`t%EditCFISettings%, EditCFISettings
menu, k, icon, Edit Settings File`t%EditCFISettings%, %icons%\settingsaltini.ico,,%is%
;---------------------------------------------------------------------------


;---------------------------------------------------------------------------
;; tray menu
gosub setmenu
traytiptext =
(
%A_ScriptName%
%Description%
)

trayicon = %icons%\changefoldericon.ico

Menu, Tray, Icon, %icons%\ChangeFolderIcon.ico
Menu, Tray, Tip, %traytiptext%

menu, tray, NoStandard
menu, Tray, Add, Show GUI`t%Show_CFICO_GUI%, Show_CFICO_GUI
menu, Tray, icon, Show GUI`t%Show_CFICO_GUI%, %icons%\ChangeFolderIcon.ico,,%is%
menu, tray, Default, Show GUI`t%Show_CFICO_GUI%
menu, tray, add, ; line -------------------------
; menu, tray, add, Settings Menu >>>`t%ShowSettingsMenu%, :s
; menu, tray, icon, Settings Menu >>>`t%ShowSettingsMenu%, %icons%\settingsaltini.ico,,%is%
; menu, tray, add, ; line -------------------------
menu, AHK, Standard
Menu, Tray, Add, AH&Ks Tray Menu >>>, :AHK
Menu, Tray, icon, AH&Ks Tray Menu >>>, %A_ahkpath%,,%is%
menu, tray, add, ; line -------------------------
menu, tray, add, Reload`t%reloadCFI%, reloadCFI
menu, tray, icon, Reload`t%reloadCFI%, %icons%\reload.ico,,%is%
Menu, tray, add, Quit \ Exit`t%exit%, exit
Menu, tray, icon, Quit \ Exit`t%exit%, %icons%\exitapp.ico,,%is%

if (A_Username = "CLOUDEN")
    Menu, Tray, MainWindow
    
if (showMenuBar) ;if (A_Username = "CLOUDEN")
{
    gosub BuildFolderHistoryMenu
    gosub setmenu
    menu, guimenu, add, Settings, :s
    menu, guimenu, add, History, :h
    menu, guimenu, add, Live Hotkeys, :K
    menu, guimenu, add, Tray Menu, :tray
    if WinExist("ahk_class dopus.lister")
        {
            Menu, guimenu, add, ¦, dummy
            Menu, guimenu, disable, ¦,
            gosub opendopustabsmenu
            gosub dopeiconmenu
            menu, guimenu, add, Dopus Open, :f
            menu, guimenu, add, Dopus Load, :d
        }
    Gui, Menu, guimenu 
}
; global darkmade 
if (DarkMode)
	{
		DarkMode := true
		DarkMode := 1
		DarkMenu(2) ; Set to ForceDark
		; gosub changefoldericonGUI
	}
	else
	{
		DarkMode := false
		DarkMode := 0
		DarkMenu(3) ; Set to ForceLight
		; gosub changefoldericonGUILightMode
	}
	


if (StartOnTop)
	pin := 1

gosub BuildMixedModechangefoldericonGUI


	

global autoLoadFolderIN := 0
global folderIN := ""

Loop %0%
{
    FolderIN := %A_Index%
    FolderIN := RegExReplace(FolderIN, "\""$", "")    ; Remove trailing quote if it exists (caused by escaped backslash)
    FolderIN := RTrim(FolderIN, "\")    ; Also remove trailing backslash to be safe
    ; msgbox %FolderIN%`n`nin auto exe autoLoadFolderIN=%autoLoadFolderIN%`n`nln=%A_LineNumber%
    autoLoadFolderIN := 1
}

if FileExist(FolderIN)
{
    autoLoadFolderIN := 1
    ; msgbox %FolderIN%`n`nin auto exe autoLoadFolderIN=%autoLoadFolderIN%`n`nln=%A_LineNumber%
    GuiControl,, folderpath, %FolderIN%
    gosub loadFolderPath
}


Return ;; first return
;--------------------------------------------------
Show_CFICO_GUI:
if WinExist("- Change Folder .Ico -")
	{
        WinRestore
        WinActivate
	}
else
	{
        gui, new
        gosub BuildMixedModechangefoldericonGUI
        ; gui, show,, - Change Folder .Ico - 
	}
return



BuildMixedModechangefoldericonGUI:  ;; start Gui mixedmode
IniREadSection("Settings")

;; onload check the clipboard for an existing filepath, if found load it automatically.
; gui, new
if (DarkMode)
{
	Gui, Font, s10 c0xBEFED3, %font% ; Consolas
	gui, color, 171717, 090909
}
else
{
	Gui, Font, s10, %font% ; Consolas
	gui, color, cd5d5d5 ;, #090909 #C8C8C8 #d5d5d5
}

gui, font, s5
gui, add, text, x0 y0 hidden, .
Gui, Font, s10

Gui, Font, s12
if (DarkMode)
	Gui, Add, Text, xm cyellow, #1 Pick a Folder to`n apply a custom icon to...
else
	Gui, Add, Text, xm, #1 Pick a Folder to`n apply a custom icon to...
Gui, Font, s10


gui, add, picture, hwndhsmenu gShowsettingsmenu w24 h24 x+m, %icons%\settingsaltini.ico
AddTooltip(hsmenu, "Settings Menu")


gui, add, picture, hwndhhkmenu gShowhotkeymenu w24 h24 x+m, %icons%\hotkeys.ico
addtooltip(hhkmenu, "Live Hotkey \ Quick Actions Menu")


gui, add, picture, x+m w24 h24 gshowopenfoldermenu hwndhOFMtt vOFM, %icons%\openfolders.ico 
AddTooltip(hOFMtt, "Open Folders of the working`nfields in your file manager.")

gui, add, text,x+m hidden, Pin\Unpin2Top

if (StartOnTop)
	gui, add, picture, x+m w28 h28 hwndhpingui vpin gpinunpin, %pinNN%
else
	gui, add, picture, x+m w28 h28 hwndhpingui vpin gpinunpin, %pinFF%
	addtooltip(hpingui, "Pin <-> Unpin`nWindow to Top")
    
if (A_IsCompiled)
{
	gui, add, picture, x+m120 w24 h24 hwndhisexe visexe gdummy, %icons%\bullseye32x32.ico
	addtooltip(hisexe, "Drag & Drop is Active.")
}
    

iconpath := A_ScriptDir "\Icons\ChangeFolderIcon.ico" ;; sets the iconpreview to the apps icon on startup when empty


Gui, Add, Button, XM vPF hwndPF hwndhpicfolder  gpickfolder , % " ... "
if (DarkMode)
{
    GuiControlGet, hwndPF , Hwnd, PF
    DllCall("uxtheme\SetWindowTheme", "ptr", hwndPF , "str", "DarkMode_Explorer", "ptr", 0)
}
addtooltip(hpicfolder, "Browse for a Folder or paste a path below.")
GuiButtonIcon(hpicfolder, icons "\explorer.ico", 0, "s16 a0")


gui, add, picture, hwndhcheckclip gcheckclipboard4FOLDER x+m w24 h24, %icons%\checkclipboard.ico
addtooltip(hcheckclip, "Check your clipboard.`nIf you have a file or folder path in it,`nclick here to load it automatically.")

Gui, Add, Button, X+M hwndhloadbut vloadbutton gLoadFolderPath  , % "  Load Folder [" LoadFolderPath "]   "
if (DarkMode)
{
	GuiControlGet, hwndloadbutton , Hwnd, loadbutton
	DllCall("uxtheme\SetWindowTheme", "ptr", hwndloadbutton , "str", "DarkMode_Explorer", "ptr", 0)
}
GuiButtonIcon(hloadbut, icons "\loadfolder.ico", 0, "s22 a1 r3")


if (RememberHistory)
	gui, add, picture, hwndhhistorybut vhashistory gshowfolderhistorymenu x+m w24 h24 , %a_scriptdir%\Icons\folderhistory.ico
else
	gui, add, picture, hwndhhistorybut vhashistory gshowfolderhistorymenu x+m w24 h24 hidden, %a_scriptdir%\Icons\folderhistory.ico

addtooltip(hhistorybut, "Pick & Reload from your history`nof 30 previously edited folders.")

if winexist("ahk_class dopus.lister")
	If FileExist(dopusrt)
		gui, add, Picture, hwndhdope x+m w24 h24 gShowLoadFolderfromDOPUSmenu, %dopusrt%
	else
		gui, add, Picture, hwndhdope x+m w24 h24 gShowLoadFolderfromDOPUSmenu, explorer.exe
AddTooltip(hdope, "Load a folder from a Dopus tab.")

addtooltip(hloadbut, "If a Path is pasted `nclick here to check its desktop.ini info.`n`nIf found it will be loaded below.")

Gui, add, text, x+m, %A_space%%A_space%
Gui, Add, Picture, x+m w24 h24 hwndhsetdvi gShowDriveMenu, %icons%\driveseticon.ico
addtooltip(hsetdvi, "Set Icon For A Hard Drive **")


;-------------------------
; if (RememberHistory)
; Gui, Add, Edit, hWndhFolderedit vfolderpath xm w475 h21 genableloadButton, %FolderPathOnClose% ;; edit1 edit 1
; else

Gui, Add, Edit, hWndhFolderedit vfolderpath xm w475 genableloadButton,  ; %A_scriptdir% ;; edit1 edit 1

addtooltip(hFolderedit, "Folder Path")
Gui, Font, s12
if (DarkMode)
	Gui, Add, Text, xm cyellow, #2 Pick an Icon file to`n apply to the above folder...
else
	Gui, Add, Text, xm , #2 Pick an Icon file to`n apply to the above folder...
Gui, Font, s10

Gui, Add, Button, XM vPI gPickIcon hWndhPI , % " ... "
if (DarkMode)
{
	GuiControlGet, hwndPI , Hwnd, PI
	DllCall("uxtheme\SetWindowTheme", "ptr", hwndPI , "str", "DarkMode_Explorer", "ptr", 0)
}
GuiButtonIcon(hPI, icons "\changefoldericonclassic.ico", 0, "s16 a0")

addtooltip(hPI, "Browse for an .Ico file or paste a path below.*`n`n** .ico format recommend.")
gui, add, picture, w24 h24 hwndhicoclip gcheckclipboard4ICO x+m, %icons%\clipboardicon.ico
addtooltip(hicoclip, "Check your clipboard.`nIf you have an .ico file in it,`nclick here to load`n& preview it automatically.")
Gui, Add, Button, vpreviewbutton gPreviewIcon x+m hwndhPreviewloadx , % "  Preview .Ico [" PreviewIcon "]  "
; % "  Load Folder [" LoadFolderPath "]   "
if (DarkMode)
{
	GuiControlGet, hwndpreviewbutton , Hwnd, previewbutton
	DllCall("uxtheme\SetWindowTheme", "ptr", hwndpreviewbutton , "str", "DarkMode_Explorer", "ptr", 0)
}
GuiButtonIcon(hPreviewloadx, "Icons\previeweye.ico", 1, "s20 a1 r5")
addtooltip(hPreviewloadx, "Load an .ico file into the`npreview box.")

if (RememberHistory)
    Gui, add, picture, x+m w24 h24 hwndhicohis gShowIconHistoryMenu, %a_scriptdir%\Icons\iconhistory.ico



addtooltip(hicohis, "Pick & Reload from your history`nof 30 previously used icons.")

Gui, Add, Picture, x+m w24 h24 hwndhfldtr gBuildLiveFolderMenuFromEdit1, %Icons%\FolderTree2.ico
; (ext != "ico") and (ext != "exe") and (ext != "dll") and (ext != "icl") Only .ico, .exe, .dll & .ico file extensions will be shown.
addtooltip(hfldtr, "A Live Folder Menu to Set icons relatively.`nOnly .ico, .exe, .dll & .icl file extensions will be shown.`n`n!Caution! Large file counts in a dir may `n make your system hang when building this menu.")
if (A_Username = "CLOUDEN")
{
    Gui, Add, Picture, x+m w24 h24 gShowInsertIconListView, %icons%\iconscrystal.ico
}

gui, add, picture, x+m w16 h16 hwndhicowarn vnoneicowarning gdllmsgbox hidden, %icons%\attention.ico ; Hidden +Border
addtooltip(hicowarn,"This icon file isn't an .ico`nClick here for more info...")
	
; gui, add, picture, x375 y115 w64 h64 hwndhicoprev vIconPreview gdonothing border, %iconpath% ; %icons%\ChangeFolderIcon.ico
gui, add, picture, x+m yp-40 w64 h64 hwndhicoprev vIconPreview gdonothing border, %iconpath% ; %icons%\ChangeFolderIcon.ico
addtooltip(hicoprev, "Icon Preview`n   ~64x64~")
If FileExist(IconsEXTnir)
{
 Gui, Add, Picture, x+m w24 h24 hwndhSaveIcoBtn1 vSaveIcoBtn1 gSaveExtractedIco1 hidden, %iconsextnir%
}
; Gui, Add, Button, x+m yp  gSaveExtractedIco  hidden, 💾 Save .ico

;---------------------------------------------------------------------------
;---------------------------------------------------------------------------
;---------------------------------------------------------------------------
Gui, Add, Edit, hWndhiconedit vIconPath genablepreviewButton xm w475,  ;gapplyicon gloadiconpreview ;; edit 2 edit2
addtooltip(hiconedit, "Icon Path")
    Gui, Add, Text, xm w475 h2 vll4 +0x10 ;add, ; line -------------------------
if (ShowAppBar)
{
    ; gui, add, text, gdonothing hwndhapps xm, Icon Apps Launcher ...
    gui, add, text, gdonothing hwndhapps xm, Icon Apps ...
    AddTooltip(happs, "Quick links for programs.`n`n**Set the paths to your Icons Apps in the setting file.`nWhen a .ico filepath is in the edit box above,`nit will open that path in your software,`nor if empty, it just launches the program.")
    if FileExist(IconViewer)
        Gui, add, picture, hwndhicv x+10+m w24 h24 vIV gIconRunner, %iconViewer%
    addtooltip(hicv, "Icon Viewer")
    if FileExist(IconEditor1)
        Gui, add, picture, hwndhice14 x+m w24 h24 vIE1 gIconRunner, %iconeditor1%
    addtooltip(hice14, "Icon Editors 1 - 4 *")
    if FileExist(IconEditor2)
        Gui, add, picture, x+m w24 h24 vIE2 gIconRunner, %iconeditor2%
    if FileExist(IconEditor3)
        Gui, add, picture, x+m w24 h24 vIE3 gIconRunner, %iconeditor3%
    if FileExist(IconEditor4)
        Gui, add, picture, x+m w24 h24 vIE4 gIconRunner, %iconeditor4%
    if FileExist(IconConverter)
        GUI, add, Picture, hwndhictt x+m w24 h24 vIC gIconRunner, %IconConverter%
    If FileExist(dopusviewer)
        GUI, add, Picture, hwnddvv x+m w24 h24 vDV gIconRunner, %dopusviewer%
    If FileExist(QuickLook)
        Gui, add, Picture, x+m w24 h24 hwndqlll vQL gIconRunner, %quicklook%
    If FileExist(iconmixer)
        Gui, add, Picture, x+m w24 h24 vIM gIconRunner, %iconmixer%
    addtooltip(hictt, "Icon Converter")
    addtooltip(dvv, "Dopus Viewer")
    addtooltip(qlll, "QuickLook")
    if FileExist(mspaint)
        Gui, add, picture, hwndhmspaint1 x+m w24 h24 vMSP gIconRunner, %mspaint% ;C:\Windows\System32\mspaint.exe
    addtooltip(hmspaint1, "Open .Ico in MS Paint")
    if Fileexist(everything15a)
        gui, add, Picture, hwndhe x+m w24 h24 vev15a gIconRunner, %everything15a%
    addtooltip(he, "Search for .Ico Files via Everything.`n`nSearch Terms from the Icon Path`nwill be sent.")
    Gui, Add, Text, xm w475 h2 vll5 +0x10 ;add, ; line -------------------------
}

;-------------------------
Gui, Add, Edit, xm w468 r6 hwndhdtipre +readonly vIniPreview Disabled, %existinginimsg% ;; inipreviw edit3
if (darkmode)
    DllCall("uxtheme\SetWindowTheme", "ptr", hdtipre , "str", "DarkMode_Explorer", "ptr", 0)


; gui, add, picture, section xm w24 h24 hwndhISINI veditdinipic gopenini hidden, %icons%\editdoc.ico ; hidden
Gui, Add, Button, xm w25 h25 HwndhISINI veditdinipic gOpenini disabled, 
GuiControlGet, HwndhISINI, Hwnd, hISINI
DllCall("uxtheme\SetWindowTheme", "ptr", hISINI, "str", "DarkMode_Explorer", "ptr", 0)

GuiButtonIcon(hISINI, Icons "\editdoc.ico", 1, "s24 A0 L1")

addtooltip(hisini, "This Folder has an existing desktop.ini file.`nYou can click here to edit it directly in notepad or default app.")

Gui, Add, CheckBox, x+m w15 h15 hwndhtbinbox vallowDELINI gAllowOptions disabled,
addtooltip(htbinbox, "Check this to allow the`nDeleting or Cleaning of this desktop.ini")

; gui, add, picture, x+y h24 w24 hwndhtbpic vDELINI gDeletedesktopini disabled, %icons%\trashbin.ico ;; disabled guicontrol,disable,delini
Gui, Add, Button, x+m w25 h25 Hwndhtbpic vDELINI gDeletedesktopini disabled, 
GuiControlGet, Hwndhtbpic, Hwnd, htbpic
DllCall("uxtheme\SetWindowTheme", "ptr", htbpic, "str", "DarkMode_Explorer", "ptr", 0)
GuiButtonIcon(htbpic, Icons "\trashbin.ico", 1, "s24 A0 L1")
addtooltip(htbpic, "Send this desktop.ini to the Recycle Bin!!`nThis will reset the icon to a default folder.`n`n**Deleting Windows system folder desktop.ini`, `ne.g. 'My Documents' can cause errors!!`nAnd Windows will usually put them back anyway.")
; guicontrol,hide,delini

; Gui, add, picture, x+m w24 h24 hwndhcleanolds vClean gCleanOLDSections hidden, %icons%\clean.ico
Gui, Add, Button, x+m w25 h25 Hwndcleanolds vClean gCleanOLDSections disabled, 
GuiControlGet, Hwndcleanolds, Hwnd, cleanolds
DllCall("uxtheme\SetWindowTheme", "ptr", cleanolds, "str", "DarkMode_Explorer", "ptr", 0)

GuiButtonIcon(cleanolds, Icons "\clean.ico", 1, "s24 A0 L1")
addtooltip(cleanolds, "Clean\Remove backed-up [.OLD.]`n Sections from this desktop.ini")
;-------------------------
gui, add, text, x+m vFPatb, 
if (DarkMode)
	gui, add, text, x+m gdonothing hwndhatb c171717, |
else
	gui, add, text, x+m gdonothing hwndhatb cC8C8C8, |

addtooltip(hatb, "Folder Path &|& desktop.ini`n Attributes")
gui, add, text, x+m vINIatb, 

; Gui, Add, Button, x+m Hwndsdii vsaveinibutton gSaveDINI hidden, % "  Save D.ini "
; GuiControlGet, Hwndsdii, Hwnd, sdii
; DllCall("uxtheme\SetWindowTheme", "ptr", sdii, "str", "DarkMode_Explorer", "ptr", 0)
; GuiButtonIcon(sdii, Icons "\saveblue.ico", 1, "s24 A0 L2")
; AddToolTip(sdii, "")

	
;-------------------------
Gui, Add, Text, xm w475 h2 vll1 +0x10 ;add, ; line -------------------------
if (ShowInfoTipExtras)
{
	Gui, Add, CheckBox, xm w204 h23 hwndhaddtt vallowTTB gAllowOptions , Add Folder Info Tip ...
	addtooltip(haddtt, "You can add an optional InfoTip here`,`nwhich will display as a comment when`nhover over this folder in a file manager.")

	Gui, Add, CheckBox, x+m h23 hwndhicodixO vChangeNumber gAllowOptions, Override IconIndex #`, *
	Gui, Add, Edit, vIconIndex gapplyicon x+y-15 w52 h21  +Disabled, 0 ; +Number ; ;; edit4
	addtooltip(hicodixO, "Apply a custom IconResource Index #`n** EXPERIMENTAL !! Click .dll attention button above.")
    Gui, Add, Picture, x+m w24 h24 gpickiconindex, %icons%\iconindex.ico
	Gui, Add, Edit, xm w468 r3 hWndhINtip +Disabled vInfoTip, ;+disabled

if (darkmode)
    DllCall("uxtheme\SetWindowTheme", "ptr", hINtip , "str", "DarkMode_Explorer", "ptr", 0)
	Gui, Add, Text, xm w475 h2 vll2 +0x10 ;add, ; line -------------------------
}


Gui, Add, Button, XM vSaveIcon gSetNewIcon w160  h34 hwndsaveicon, Set Icon [%setnewicon%]
if (DarkMode)
{
	GuiControlGet, hwndSaveIcon , Hwnd, SaveIcon
	DllCall("uxtheme\SetWindowTheme", "ptr", hwndSaveIcon , "str", "DarkMode_Explorer", "ptr", 0)
}
; GuiButtonIcon(SaveIcon, File, Index := 1, Options := "")
GuiButtonIcon(SaveIcon, "Icons\savegreen.ico", 1, "s32 a0 l5")

gui, add, picture, x+m section h16 w16, %icons%\forcewinreload.ico
if (ForceApplyNOW)
	Gui, Add, CheckBox, hWndhREXPtip vforcewindownsreload gapplyicon x+m +Checked, Force Windows to Apply Icon New Now !** ; x16 y488 w226 h41 gapplyicon
else
	Gui, Add, CheckBox, hWndhREXPtip vforcewindownsreload gapplyicon x+m , Force Windows to Apply Icon New Now !** ; x16 y488 w226 h41 gapplyicon
addtooltip(hrexptip,"When Checked --> This will force a restart of Windows Explorer`nand reloads windows icon cache, to apply new icons instantly.`n`n**! It will close any File Explorer windows you have open!`nIf you're using Dopus ignore this.")

gui, add, picture, xs h16 w16, %icons%\foldertree.ico
Gui, Add, CheckBox, hWndhallsubswarn vapplytoallsubs gapplyicon x+m, Apply this Icon to ALL Subfolders ** 
addtooltip(hallsubswarn,"This will create a desktop.ini file in every`nsub-folder below the chosen path so that`nthe entire folder tree will have the same icon.`n`n**All other ini settings will be reset to Generic!")
;"
Gui, add, picture, xm h16 w16, %icons%\min_copyTo_32x32.ico
Gui, add, checkbox, x+m hwndhcopytotip gEnableHideIco vCopyIcoToDest  Checked%CopyIcoToDest% gToggleCopyIcoToDest, Copy .ico to Dest
; box(copyicoTodest)
addtooltip(hcopytotip, "Copies .ico to the active folder path and sets the icon as relative.`nMake the icon portable.")
If (CopyIcoToDest)
Gui, add, checkbox, x+m hwndhhidcopy vHideLocalIco  Checked%HideLocalIco% gToggleHideLocalIco, Hide Copied .ico
else
Gui, add, checkbox, x+m hwndhhidcopy vHideLocalIco  Checked%HideLocalIco% gToggleHideLocalIco disabled, Hide Copied .ico
addtooltip(hhidcopy, "Hides the copied .ico like the desktop.ini`n*Optional & Sticky")
Gui, Add, Text, xm w475 h2 vll3 +0x10 ;add, ; line -------------------------



Gui, Add, Button, XM vei gexit w190 hwndhexi , Quit\Exit - [%exit%]
if (DarkMode)
{
	GuiControlGet, hwndei , Hwnd, ei
	DllCall("uxtheme\SetWindowTheme", "ptr", hwndei , "str", "DarkMode_Explorer", "ptr", 0)
}
GuiButtonIcon(hexi, "Icons\exitapp.ico", 1, "s20 a1 r10")



Gui, Add, Button, X+M vre gReload w190 hwndhrestbut , Reload App - [%reloadCFI%]
if (DarkMode)
{
	GuiControlGet, hwndre , Hwnd, re
	DllCall("uxtheme\SetWindowTheme", "ptr", hwndre , "str", "DarkMode_Explorer", "ptr", 0)
}
AddTooltip(hrestbut, "Reload CFI to Clear & Reset all input boxes")
GuiButtonIcon(hrestbut, "Icons\reload.ico", 1, "s20 a1 r10")
;-------------------------
Gui, Add, Button, XM vFastset gfastsetnewicon w387 hwndhanE , Fast Set - Apply Now! && Exit - [%fastsetnewicon%]
if (DarkMode)
{
	GuiControlGet, hwndFastset , Hwnd, Fastset
	DllCall("uxtheme\SetWindowTheme", "ptr", hwndFastset , "str", "DarkMode_Explorer", "ptr", 0)
}
addtooltip(hanE, "For a Speedy Icon Change -->`nApply Icon`nReload Windows Explorer`nand Exit This App!")
GuiButtonIcon(hanE, "Icons\arrowquick.ico", 1, "s20 a1 r10")






if (devmode)
{
    Gui, add, edit, xm w275 vSearchTerm,
    ; Gui, add, button, x+m gEditCFICO, &Edit
    Gui, Add, Button, x+m Hwndedgg vedbb gEditCFICO, % "  &Edit  "
    GuiControlGet, Hwndedgg, Hwnd, edgg
    DllCall("uxtheme\SetWindowTheme", "ptr", edgg, "str", "DarkMode_Explorer", "ptr", 0)
    GuiButtonIcon(edgg, te, 1, "s24 A0 L2")
}

Gui, +hWndhMainWnd  +Border +LastFound +E0x10 +Resize -MaximizeBox ; +0x200 ; GuiDropFiles


if (StartOnTop)
	Gui,  +AlwaysOnTop

if (RememberWindowPos)
{
    IniRead, X, %IniFile%, Settings, X, 500
    IniRead, Y, %IniFile%, Settings, Y, 500
    Gui, Show, x%X% y%Y%, - Change Folder .Ico -
}
else
	Gui, Show, , - Change Folder .Ico - 

guicontrol,focus,folderpath

if (OnStartUp_AutoLoadLastFolder)
{
    guicontrol,,Folderpath,%FolderPathOnClose%
    gosub loadFolderPath
    gosub previewicon
}

if (ResetFlag != "")
{ ; box("resetflag seen`n" resetflag)
    iniwrite, %resetflag%, %inifile%, Settings, OnStartUp_AutoLoadLastFolder
    sleep 100
    inidelete, %inifile%, Settings, ResetFlag

; iniread, current_autoloadstatus, %inifile%, Settings, OnStartUp_AutoLoadLastFolder
; iniwrite, %current_autoloadstatus%, %inifile%, Settings, ResetFlag
}

if (AutoCheckClipboard4Path)
	gosub checkclipboardonload



if (RestorePrevious)
{
    guicontrol,,folderpath,%RestoreF%
    gosub Loadfolderpath
    sleep 150
    guicontrol,,iconpath,%RestoreI%
    gosub PreviewIcon
    ; IniDelete, Filename, Section [, Key]
    IniDelete, %inifile%, settings , RestorePrevious
    IniDelete, %inifile%, settings , RestoreF
    IniDelete, %inifile%, settings , RestoreI

}

; if (A_Username = "CLOUDEN")
	; Gui, Show, x2607 y786, - Change Folder .Ico - 
	; Gui, Show, x%X% y%Y%, - Change Folder .Ico - 

; if (RememberHistory)
	; {
		; if (FolderPathOnClose != "")
			; {
				; GuiControl,,folderpath,%FolderPathOnClose%
				; gosub loadfolderpath
			; }
		; else if (IconPathOnClose != "")
			; {
				; guicontrol,,iconpath,%IconPathOnClose%
				; gosub PreviewIcon
			; }
	; }
; if FileExist(FolderIN)
/*

 if (autoLoadFolderIN)
{
; msgbox, %folderIN%`n`nwas sent and seen in the script in Dark GUI... now... gosub loadpath??
gosub loadFolderPath
} 

*/



if (debugonstartup)
	listlinesx()
return ;; end GUI Mixed-Mode ;;  ;; first return 2nd return mixed mode mixed Bottom of gui
;; first return
;---------------------------------------------------------------------------




#ifwinactive - Change Folder .Ico - ahk_class AutoHotkeyGUI
~Lbutton:: ;; double click to select all in edit boxes
if (A_PriorHotkey != "~Lbutton" or A_TimeSincePriorHotkey > 300)
	{
		KeyWait, Lbutton, u
		return
	}
else
	{
		sleep 20
		send ^a
	}
return

!e:: ;; edit source, searches edit if !empty
gosub EditCFICO 
return
^f:: ;; focus find box
GuiControl,Focus,SearchTerm
return
#ifwinactive 

EditCFICO:
    Gui, submit, nohide
    OpenFileToFoundText(SourceScript, SearchTerm)
return

dummy:
donothing:
return
enableloadButton:
GuiControl,show,loadbutton
return
enablepreviewbutton:
gui,submit,nohide
if FileExist(iconpath)
{
    SplitPath,iconpath,,,ext
    if (ext = "ico")
        {
            GuiControl,show,previewbutton
            return
        }
}
return

AllowOptions:
gui, submit, nohide
if (allowTTB=1)
	guicontrol,Enabled,InfoTip
else
	guicontrol,Disabled,InfoTip
; if (allowFT)
	; guicontrol,enabled,ApplyFolderType
; else
	; {
	; guicontrol,Disabled,ApplyFolderType
	; GuiControl, Choose, ApplyFolderType, 1
	; }
if (ChangeNumber)
	GuiControl,Enable,IconIndex
else
{
    GuiControl,Disabled,IconIndex
    guicontrol,text,IconIndex,0
}
if (allowDELINI)
{
    GuiControl,Enable,DELINI
    If FileExist(desktopini)
        guicontrol,enable,Clean
}
else
{
	GuiControl,Disable,DELINI
    If FileExist(desktopini)
        GuiControl,Disable,clean
}
return

openini:
If FileExist(ActiveARinf)
{
    try, run, notepad++.exe "%ActiveARinf%"
    catch
    try, run, notepad.exe  "%ActiveARinf%"
    return
}
try run, "%desktopini%"
catch
try run, nopepad++.exe "%desktopini%"
catch
try run, notepad.exe "%desktopini%"
return



Browse4FOLDERtoLoad:
pickfolder:
FileSelectFolder, folderpath, *C:\Users\%a_username%,6,Select A Folder that you want to set a custom Icon to...
if !FileExist(folderpath) ;; this should never happen with the fileseletfolder but just-in-case.
	{
	tooltip, ERR! @ Line:  %A_LineNumber% -- %A_scriptname%`n`nFolder Doesn't Exist! Operation Canceled.
	SetTimer, RemoveTooltip, -2000	
	return	
	}
GuiControl,, folderpath, %folderpath%
; guicontrol,show,OFM
Gosub, loadFolderPath 
Return

checkclipboard4FOLDER:
if FileExist(clipboard)
	gosub checkclipboardonload
else
{
    tooltip, Your clipboard does not contain`nan existing folder\file path.
    SetTimer, RemoveTooltip, -2000	
}
return
checkclipboardonload:
;; onload check the clipboard for an existing filepath, if found load it automatically into the folderpath.
if FileExist(clipboard)
{
	SplitPath,clipboard,,,ext
	if (ext = "ico")
    {
        GuiControl,,iconpath,%clipboard%
        gosub PreviewIcon
        if !(skiptip)
            gosub autoloadtt
        skiptip := 0
        return
    }
	else
	{
		FileGetAttrib, clipboardcheck, %clipboard%
		if InStr(clipboardcheck, "D")
        {
            guicontrol,,folderpath,%clipboard%
            gosub LoadFolderPath
            if !(skiptip)
                gosub autoloadtt
            skiptip := 0
            Return
        }
    else
        {
            SplitPath,clipboard,filename,folderpath
            guicontrol,,folderpath,%folderpath%
            gosub LoadFolderPath
            if !(skiptip)
                gosub autoloadtt
            skiptip := 0
            Return
        }
	}
}
return

autoloadtt:
tooltip Your clipboard contained an`nexisting folder path or icon.`nIt was automatically loaded into the GUI...
SetTimer, RemoveTooltip, -3000
return


GuiDropFiles:
Gui , Submit , NoHide
Loop, Parse, A_GuiEvent, `n ; EXAMPLE #2: To extract only the first file, follow this example:
{
    FirstFile := A_LoopField
    break
}

SplitPath, firstfile, filename, dir, ext
; msgbox dropped file: %firstfile%`n`nfilename: %filename% `ndir: %dir%`next: %ext%

if (ext = "ico")
{
    GuiControl,, IconPath, %FirstFile%    ; Update Icon Path (modify if needed)
    goto PreviewIcon
}
if (ext = "exe")
{
    GuiControl,, IconPath, %FirstFile%    ; Update Icon Path (modify if needed)
    FolderPath := SubStr(FirstFile, 1, InStr(FirstFile, "\",, 0))  ; Extract parent folder
    GuiControl,, FolderPath, %FolderPath%  ; Update GUI with folder path
    gosub PreviewIcon
    goto LoadFolderPath
}
else
{
    if InStr(FileExist(FirstFile), "D")  ; If it's a directory
        {
            FolderPath := FirstFile
            GuiControl,, FolderPath, %FirstFile%  ; Update Folder Path
        }
    else
        {
            FolderPath := SubStr(FirstFile, 1, InStr(FirstFile, "\",, 0))  ; Extract parent folder
            GuiControl,, FolderPath, %FolderPath%  ; Update GUI with folder path
        }
    gosub LoadFolderPath
    gosub PreviewIcon
}
; if (filename = "desktop.ini")
; {
    ; folderpath := dir
    ; goto loadFolderPath
; }

Return 

resetCFIgui: ; #TODO ** and then order them. ** √ ~~this needs a 3rd label reset:, update:, and cleanup:~~
GuiControl,, folderpath
; guicontrol,hide,OFM
; GuiControl,hide,loadbutton
updateCFIgui: ;; if 
GuiControl,, IconPath ; %iconpath%  ; Update icon edit box
GuiControl,, IconPreview ; %iconpath%  ; Update icon preview
guicontrol,, ChangeNumber,0
GuiControl,, IconIndex, 0 ; %iconindex%  ; Update icon index
;-------------------------
; GuiControl,hide,loadbutton
guicontrol,,IniPreview,%existinginimsg%
guicontrol,disable,editdinipic
guicontrol,disable,delini
guicontrol,disable,allowdelini
guicontrol,,allowdelini,0
guicontrol,disable,clean
guicontrol,hide,noneicowarning
guicontrol,hide,saveinibutton
guicontrol,disabled,IniPreview
guicontrol,, allowTTB,0
guicontrol,disabled,InfoTip
guicontrol,,InfoTip
guicontrol,,FPatb,
guicontrol,,INIatb,

; guicontrol,,HideLocalIco,0
; guicontrol,disable,HideLocalIco
; guicontrol,,CopyIcoToDest,0


; guicontrol,disabled,ApplyFolderType
; cleanupCFIgui: ;; if #todo do i need a third clean up here???
; guicontrol,, allowFT,0
return
;-------------------------
LoadFolderPath: ;; load the pasted folder path , read existing icon info from a desktop.ini if found
folderpath := ""
iconpath := ""
iconext := ""
noneicowarning := ""
IconResource := ""
iconindex := ""
ActiveARinf := ""

autoLoadFolderPath:
; sleep 10
gui, submit, nohide
folderpath := Trim(folderpath, "\")
guicontrol,,folderpath,%folderpath%
;; reset guicontrols from the start
; sleep 50
gosub updateCFIgui
sleep 50

FileGetAttrib, filecheck, %folderpath% ; check if the pasted path is a file. && that it exists ; msgbox %filecheck%
; box(filecheck)
if InStr(filecheck,"D") ;; it's a folder
{
    ; guicontrol,show,OFM
    guicontrol,,FPatb,%filecheck%
    goto inicheck
}
else ; it's a file check
{
	SplitPath, folderpath, , FileCheckDir
	folderpath := FileCheckDir
	if !FileExist(folderpath)
    {
        Tooltip, ERR! @ Line#:  %A_LineNumber%`nThe Folder path pasted here cannot be found!
        SetTimer, RemoveTooltip, -2000	
        Return
    }
	else
    {
        GuiControl,, folderpath, %filecheckdir%
        FileGetAttrib,filecheck, %filecheckdir%
        guicontrol,,FPatb,%filecheckdir%
        Tooltip, This is FILE. Loading the Parent Directory instead.`nFinal Path: %folderpath%
        SetTimer, RemoveTooltip, -2000
        ; guicontrol,show,OFM
        goto inicheck
    }
}
; gosub PreviewIcon
return
readdesktopini:
inicheck:
; if FileExist(desktopIni)  ; Check if desktop.ini exists, read and load it content into the gui.
; { 
; fileread, inicontent, %desktopini%
; guicontrol,,IniPreview, %inicontent%
; }

inireaderror := "There was an ERROR reading this desktop.ini file."
inireadempty := "There was no content in this desktop.ini`nThere was not text found in it."

desktopIni := folderpath "\desktop.ini" ;; look for a desktop.ini file
arinf := folderpath "\autorun.inf"
If FileExist(arinf)
{
    ; box(arinf A_nl A_LineNumber) ;; good
    activearinf := arinf
    FileRead, infcontent, %arinf% ; Read desktop.ini content
    GuiControl,enable,IniPreview, ; %inicontent%
    GuiControl,,inipreview,%infcontent%
    guicontrol,Enable, allowDELINI
    guicontrol,enable,editdinipic
    IniRead, Icon, %arinf%, autorun, Icon, %A_Space%
    iconfile := folderpath "\" icon
    goto skippeddini
    ;; gosub loadrelativeicon ?
}
if !FileExist(desktopini) ;; if a desktop.ini file doesn't exits reset all the guicontrols except the folder
{
    goto updateCFIgui ;; this clears preloaded icons? #todo
    ; gosub cleanupCFIgui
    return ;; and stop
}

FileRead, inicontent, %desktopini% ; Read desktop.ini content
FileGetAttrib,INIatb,%desktopini%
GuiControl,,iniatb,%iniatb%
if (inicontent = "")
{ ;; the desktopini is empty or can't be read
    GuiControl,,inipreview,%inireadempty%
}
	
if (inicontent = "ERROR")
{ ;; the desktopini is empty or can't be read
    GuiControl,,inipreview,%inireaderror%
}
	

GuiControl,enable,IniPreview, ; %inicontent%
GuiControl,,IniPreview,%inicontent%
guicontrol,enable,allowdelini
guicontrol,enable,editdinipic
guiControl,show,saveinibutton
; GuiControl,enable,clean
; guicontrol,show,delini
; guicontrol,disable,delini

; if (ShowInfoTipExtras) ; read and load InfoTip
; {
; }  this should be read weather or not the infotip is hidden on Gui, and now that this can read exe,dlls, this sub section should always be visible? remove it from Menu, s, add, hide optional, kk, removed from menu and makeini label, thou user can still override it they know how
    IniRead, InfoTip, %desktopini%, .ShellClassInfo, InfoTip, %A_space%
    if (InfoTip != "")
        guicontrol,,InfoTip,%InfoTip%

goto inilookforicon
return
;-------------------------
ShowError(lineNum, folderpath, IconResource, iconpath, iconfile, iconindex, desktopini)
	{
        MsgBox wtfahk Error at line %lineNum% .`n`nFolderPath: %folderpath%`n`nIconResource=%IconResource%`n`nIconPath= %iconpath%`nIconFile=%iconfile%`n`niconindex`,%iconindex%`n`nReading desktop.ini: %desktopini%`n
	}
; ShowError(A_LineNumber, folderpath, IconResource, iconpath, iconfile, iconindex, desktopini)
;-------------------------
inflookforicon:


goto skippeddini

inilookforicon:
; GuiControlGet, currentIconPath,, iconpath
; Try reading "IconResource" first, this is most common
IniRead, IconResource, %desktopIni%, .ShellClassInfo, IconResource, %A_Space%
IniRead, IconFile, %desktopIni%, .ShellClassInfo, IconFile, %A_Space%

; if ((IconResource != "" || IconFile != "") && currentIconPath != IconResource && currentIconPath != IconFile || iconpath = "")
; if ((IconResource != "" || IconFile != "") && (currentIconPath != IconResource && currentIconPath != IconFile)) || (currentIconPath = "")
	; {
		; GuiControl,, iconpath  ; Clear the current iconpath
		; guicontrol,,iconpreview,
		; GuiControl,, iconpath, % (IconResource != "" ? IconResource : IconFile)
		; ShowError(A_LineNumber, folderpath, IconResource, iconpath, iconfile, iconindex, desktopini)
	; }
skippeddini:
;-------------------------  START GETINIICON LOGIC
if (IconResource = "" && iconfile = "")
{
    ; No IconResource and no IconFile - Possibly no desktop.ini or Windows CLSID folder
    ; ShowError(A_LineNumber, folderpath, IconResource, iconpath, iconfile, iconindex, desktopini)
    ; guicontrol,,iconpath, No iconpath was found in this desktop.ini
} 
else if (IconResource != "" && iconfile = "")
{
    ; IconResource exists correctly, and no IconFile is present
    goto SeparateIconResource
    ; ShowError(A_LineNumber, folderpath, IconResource, iconpath, iconfile, iconindex, desktopini)
} 
else if (IconResource != "" && iconfile != "")
{
    ; Both IconResource and IconFile exist - Should IconFile be removed?
    goto SeparateIconResource
    ; ShowError(A_LineNumber, folderpath, IconResource, iconpath, iconfile, iconindex, desktopini)
}
else if (IconResource = "" && iconfile != "")
{
    ; IconFile exists and needs to be converted to IconResource
    if (ShowInfoTipExtras)
    {
        IniRead, IconIndex, %desktopIni%, .ShellClassInfo, IconIndex, 0
        guicontrol,,IconIndex,%iconindex%
    }
    if FileExist(iconfile)
    {
        guicontrol,,iconpath,%iconfile%
        gosub checkico
    }
    else
        gosub findiconpath
    ; ShowError(A_LineNumber, folderpath, IconResource, iconpath, iconfile, iconindex, desktopini)
} 
return



;; broken, not seeing relative paths
SeparateIconResource:
if (IconResource != "")
{


RegExMatch(IconResource, ",[[:space:]]*([-]?\d+)$", match) ; Set the icon index to the GUI control (defaults to 0 if not found)
iconindex := match1 != "" ? match1 : 0
guicontrol,,IconIndex,%iconindex%
iconpath := RegExReplace(IconResource, ",[[:space:]]*[-]?\d+$", "")
guicontrol,,iconpath,%iconpath%

        ; ShowError(A_LineNumber, folderpath, IconResource, iconpath, iconfile, iconindex, desktopini)
    if FileExist(iconpath)
    {
        ; ShowError(A_LineNumber, folderpath, IconResource, iconpath, iconfile, iconindex, desktopini)
        guicontrol,,iconpath,%iconpath%
        gosub checkico
    }
    else
    {
        ; ShowError(A_LineNumber, folderpath, IconResource, iconpath, iconfile, iconindex, desktopini)
        gosub findiconpath
    }
}
	;-------------------------
return 






;------------------------- 
useIconresource:
checkini_break: ;; mostly fixed the handling of the the iconpath below this point, 04-01-2026 - todo-revisit
;-------------------------
findiconpath:
locateiconfile:
if (iconpath != "ERROR")  ; If an icon path is found 
    {
		if instr(iconpath, "%")  ; Normalize environment variables
        {
            EnvGet, sysRoot, SystemRoot
            iconPath := StrReplace(iconPath, "%SystemRoot%", sysRoot)
            iconPath := StrReplace(iconPath, "%WinDir%", sysRoot)
            goto skippedrelative
        ; ShowError(A_LineNumber, folderpath, IconResource, iconpath, iconfile, iconindex, desktopini)
        ; gosub checkico
        }
        
        if !InStr(iconpath, ":") ; Handle relative paths for "IconFile" ; No drive letter or full path
			If instr(iconpath, "\")
            {
            ; ShowError(A_LineNumber, folderpath, IconResource, iconpath, iconfile, iconindex, desktopini)
                iconpath := folderpath iconpath
            }
        else
            {
                if (IconResource = "")
                {
                    iconpath := folderpath "\" iconfile  ; Convert to absolute path ;; todo but he icon might be in sub dir of the folder e.g., iconfile=\icons\thisicon.ico
                    ; ShowError(A_LineNumber, folderpath, IconResource, iconpath, iconfile, iconindex, desktopini)
                }
                else
                {
                    iconpath := folderpath "\" iconpath 
                    ; ShowError(A_LineNumber, folderpath, IconResource, iconpath, iconfile, iconindex, desktopini)
                    guicontrol,,iconpath,%iconpath%
                    ; iconpath := folderpath "\" IconResource 
                }
            }

		; ShowError(A_LineNumber, folderpath, IconResource, iconpath, iconfile, iconindex, desktopini)
return
skippedrelative:
; return
        ; Update GUI
        GuiControl,, IconPath, %iconpath%  ; Update icon edit box
		IconPath := GetFileIcon(folderpath)
        GuiControl,, IconPreview, *w64 *h64 %IconPath%  ; Update icon preview ;; og
		gosub checkico
		; guicontrol,, iconpreview, w64 h64 
		; When setting icon preview
		; GuiControl,, IconPreview, *icon %IconPath%  ; This might give better scaling ;; claude 1
		; GuiControl,, IconPreview, *icon64 %IconPath% ;; claude 2

    }
    else
    {
			; ShowError(A_LineNumber, folderpath, IconResource, iconpath, iconfile, iconindex, desktopini)
        GuiControl,, IconPreview, *w64 *h64 %iconerror%  ; Set to default error icon
    }

return
checkico:
GuiControlGet, currentIconPath,, iconpath
gui, submit, nohide

global iconpath, nonicowarning
if FileExist(iconpath)
	{
	SplitPath, iconpath, ,,iconext
	; MsgBox, path: %iconpath%`n`next: %iconext%`n`nIfile: %iconfile%`n`niRescour: %IconResource%
	if (iconext = "ico")
		{
		; msgbox iconfile: %iconfile% `n`niconpath %iconpath%
		guicontrol,hide,noneicowarning
		GuiControl,show,previewbutton
		GuiControl,, IconPreview, *w64 *h64 %IconPath%  ; Update icon preview
		guicontrol,,iconpath,%iconpath%
		gosub previewicon
		 ; GuiControl,, IconPreview, *icon64 %IconPath% ;; claude 2
		; return
		}
	else
		{
		GuiControl,show,noneicowarning
		gosub trytoloaddll
		; GuiControl,, IconPreview, *w64 *h64 %IconPath%  ; Update icon preview
		}
	; guicontrol,,iconpreview,%iconpath%
	}
return
trytoloaddll:
; return
        ; Update GUI
		; guicontrol,,iconpath,
        GuiControl,, IconPath, %iconpath%  ; Update icon edit box
		IconPath := GetFileIcon(folderpath)
        GuiControl,, IconPreview, *w64 *h64 %IconPath%  ; Update icon preview ;; og
return


PreviewIcon:
    gui, submit, nohide
    if !FileExist(iconpath)
    {
        ; try checking if it relative
        relativecheck := folderpath "\" iconpath
        If FileExist(relativecheck)
        {
            iconpath := relativecheck
            goto foundrelativepreview
        }
        else
        {
            Tooltip, ERR! This File Cannot be found.`n  @ Line#:  %A_LineNumber%
            SetTimer, RemoveTooltip, -2000
            return
        }
    }
foundrelativepreview:
    SplitPath, iconpath,,, ext

    if (ext = "ico")
    {
        guicontrol,, iconpreview, *w64 *h64 %iconpath%
        GuiControl, Hide, SaveIcoBtn1  ; not needed for .ico
        return
    }
; box(iconpath A_nl A_linenumber)

    ; for exe/dll/icl extract the icon at the chosen index to a temp ico
    idx := iconindex + 0
    
    tempico := A_Temp "\~iconpreview.ico"
; box(iconpath A_nl A_linenumber A_nl idx A_nl tempico) 

    ; strip index from iconpath if it contains one
if RegExMatch(iconpath, "^(.+),(\d+)$", m)
{
    cleanpath := m1
    idx := m2
}
else
{
    cleanpath := iconpath
    idx := iconindex + 0
}
; box(iconpath A_nl A_linenumber A_nl idx A_nl tempico A_nl cleanpath A_nl if_iconindex)
    ; hIcon := DllCall("shell32\ExtractIcon", "ptr", 0, "str", iconpath, "int", idx, "ptr") < - causing crash
    hIcon := DllCall("shell32\ExtractIcon", "ptr", 0, "str", cleanpath, "int", idx, "ptr")

    if !hIcon
    {
        tooltip, Could not extract icon at index %idx%
        guicontrol,,IconPreview,*w64 *h64 %iconerror%
        SetTimer, RemoveTooltip, -2000
        return
    }

    previewpath := SaveHIconToIco(hIcon, tempico)    ; write hIcon to temp .ico file
if (previewpath != "" && FileExist(previewpath))
{
    guicontrol,, iconpreview, *w64 *h64 %previewpath%
    GuiControl, Show, SaveIcoBtn1
}

    DllCall("DestroyIcon", "ptr", hIcon)
return
SaveHIconToIco(hIcon, filepath)
{ ; v5 Scribbles
    global gdipToken

    hScreen := DllCall("GetDC", "ptr", 0, "ptr")
    hdc := DllCall("CreateCompatibleDC", "ptr", hScreen, "ptr")
    hbm := DllCall("CreateCompatibleBitmap", "ptr", hScreen, "int", 64, "int", 64, "ptr")
    DllCall("ReleaseDC", "ptr", 0, "ptr", hScreen)
    DllCall("SelectObject", "ptr", hdc, "ptr", hbm)
    DllCall("DrawIconEx", "ptr", hdc, "int", 0, "int", 0
        , "ptr", hIcon, "int", 64, "int", 64, "uint", 0, "ptr", 0, "uint", 3)

    DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", "ptr", hbm, "ptr", 0, "ptr*", pBitmap)


    VarSetCapacity(clsid, 16)    ; use PNG encoder instead - ICO encoder unreliable
    DllCall("ole32\CLSIDFromString"
        , "wstr", "{557CF406-1A04-11D3-9A73-0000F81EF32E}"  ; PNG
        , "ptr", &clsid)


    pngpath := RegExReplace(filepath, "\.\w+$", ".png")    ; save as .png regardless of filepath extension - just for preview
    DllCall("gdiplus\GdipSaveImageToFile", "ptr", pBitmap, "wstr", pngpath, "ptr", &clsid, "ptr", 0)
    DllCall("gdiplus\GdipDisposeImage", "ptr", pBitmap)
    DllCall("DeleteObject", "ptr", hbm)
    DllCall("DeleteDC", "ptr", hdc)
    return pngpath  ; return png path instead of ico path
}



TogglePin()
{
    global Pin
    if (pin)
        Gui, -AlwaysOnTop
    else
        Gui, +AlwaysOnTop
}

SaveExtractedIco1:
Gui, submit, nohide
If FileExist(iconsextnir)
{
    run, %iconsextnir% -scanpath "%iconpath%"

}
return

SaveExtractedIco2:
;; or could use nirsoft icoextractor here. or mitec's
If FileExist(icofx)
{
    run, %icofx% "%iconpath%"
}
return



Browse4ICONtoLoad:
pickicon:
FileSelectFile, iconpath, 1, %IconLibrary%, Select an Icon File., Icon Files (*.ico;*.exe;*.dll;*.icl)
if (IconPath = "")
	return
guicontrol,text,IconPath,%IconPath%
; guicontrol,,iconpreview, *w64 *h64 %iconpath%
gosub PreviewIcon  ; handles all exts now instead of raw guicontrol
Return

PickIconIndex:
WinGetPos , gx, gY, , , - Change Folder .Ico - ahk_class AutoHotkeyGUI ;, WinText, ExcludeTitle, ExcludeText
if (pin)
{
    gosub pinunpin
    sleep 200
    repin := 1
}
    GuiControlGet, iconpath,, iconpath  ; get current edit value
    If !FileExist(iconpath) ;; check relative
    {
        pathcheck := folderpath "\" iconpath
        If FileExist(pathcheck)
            iconpath := pathcheck
        else
        {
            Box("There's an error finding the icon path!")
            Return
        }
    }
    SplitPath, iconpath,,, ext
    if (ext != "exe") and (ext != "dll") and (ext != "icl")
    {
        tip("PickIconDlg only works with .exe .dll .icl files")
        return
    }
    SetTimer, MovePickIconDlg, -200  ; fire 100ms after dialog opens
    VarSetCapacity(iconBuf, 520, 0)
    StrPut(iconpath, &iconBuf, 260, "UTF-16")
    iconIndex := IF_IconIndex ? IF_IconIndex : 0
    result := DllCall("shell32\PickIconDlg"
        , "ptr", hself        ; parent hwnd of your gui
        , "ptr", &iconBuf
        , "uint", 260
        , "int*", iconIndex)
    ; sleep 850
    ; x := gx + 200
    ; y := gy + 200
    ; WinMove, Change Icon ahk_class #32770, &Look for icons in this file:, %X%, %Y% ; [, Width, Height, ExcludeTitle, ExcludeText]
    if result
    {
        iconpath := StrGet(&iconBuf, "UTF-16")
        guicontrol,, iconpath,  %iconpath%
        guicontrol,, iconindex, %iconIndex%
        IF_IconIndex := iconIndex
        guicontrol,, ChangeNumber, 1  ; keep checkbox checked
        if (repin)
        {
            gosub pinunpin
            repin := 0
        }
        gosub PreviewIcon
    }
    else
    {
        if (repin)
        {
            gosub pinunpin
            repin := 0
        }

    }
return

MovePickIconDlg:
    if WinExist("Change Icon ahk_class #32770")
    {
        ; if (pin)
        ; {
            ; Gui, -AlwaysOnTop
            ; repin := 1
        ; }
        x := gx + 200
        y := gy + 200
        WinMove, Change Icon ahk_class #32770,, %x%, %y%
        SetTimer, MovePickIconDlg, off
    }
return

checkclipboard4ICO:
if FileExist(clipboard)
	{
	FileGetAttrib, foldercheck, %clipboard%
	
	if (InStr(foldercheck, "D"))
		{
			Tooltip, Sorry your clipboard contains a folder.`nTry Loading that above.`nNeed and .ico file here
			SetTimer, RemoveTooltip, -3000	
			return		
		}
	else ; if its file, check for ico
		{
		SplitPath,clipboard,,,ext
		; msgbox ext %ext%`n`nc: %clipboard%`n`nip:  %iconpath%
		if (ext = "ico")
			{
				guicontrol,text,iconpath,%clipboard%
				guicontrol,show,OFM
				guicontrol,hide,noneicowarning
				guicontrol,,iconpreview,%iconpath%
				goto PreviewIcon
			}
		else
			{
				tooltip Sorry at the moment this`n preview can only handle .ico files
				SetTimer, RemoveTooltip, -2500
				return
			
			}
		
		}
	}
else
	{
		tooltip, Your clipboard does not contain`nan existing file path.
		SetTimer, RemoveTooltip, -2000	
	}
return


runicon:

ControlGetText, iconfilepath, Edit2, - Change Folder .Ico - ahk_class AutoHotkeyGUI,
if (iconfilepath = "")
	{
	tooltip there's nothing there
	SetTimer, RemoveTooltip, -2000	
	return
	}

if FileExist(iconfilepath)
	{
	SplitPath, iconfilepath,,,iconfileext
		msgbox ife: %iconfileext%`n`nIFP: %iconfilepath%`n`nIP: %iconpath%
	if (iconfileext != "ico")
		{
			Tooltip You can only try to edit`n.ico file from here.
			SetTimer, RemoveTooltip, -2000	
			return
		}
	else
	if (iconfileext = "ico")
		{

			try run "%iconfilepath%"
			catch
			try run C:\Program Files\XnViewMP\xnviewmp.exe "%iconfilepath%"
			catch
			try run icofx.exe "%iconfilepath%"
			catch
			try run photoshop.exe "%iconfilepath%"
			catch 
			try run paint.exe "%iconfilepath%"
		}
	}
return

Toggleappbar:
ShowAppBar := !ShowAppBar
if (ShowAppBar)
	{
		iniwrite, 1, %inifile%, Settings, ShowAppBar
		menu, s, togglecheck, Hide the App Bar
	}
else
	{
		iniwrite, 0, %inifile%, Settings, ShowAppBar
		menu, s, togglecheck, Hide the App Bar
	}
tooltip, This change requires a reload to take affect...
SetTimer, RemoveTooltip, -3000	
return
Toginfotips:
ShowInfoTipExtras := !ShowInfoTipExtras
if (ShowInfoTipExtras)
	{
		iniwrite, 1, %inifile%, Settings, ShowInfoTipExtras
		; menu, s, togglecheck, Hide Optional Folder Info Tip Extras
	}
else
	{
		iniwrite, 0, %inifile%, Settings, ShowInfoTipExtras
		; menu, s, togglecheck, Hide Optional Folder Info Tip Extras
	}
tooltip, This change requires a reload to take affect...
SetTimer, RemoveTooltip, -3000
sleep 1500
reload
return

IconRunner:
gui, submit, nohide
ControlGetText, iconfilepath, Edit2, - Change Folder .Ico - ahk_class AutoHotkeyGUI,
if (A_GuiControl = "IM")
    {
        Run, %iconmixer%
        return
    }
if (iconfilepath = "")
	{
		tooltip Launching...
		SetTimer, RemoveTooltip, -1000
		if (A_GuiControl = "IV")
			Run, %IconViewer%
		else if (A_GuiControl = "IE1")
			Run, %IconEditor1%
		else if (A_GuiControl = "IE2")
			Run, %IconEditor2%
		else if (A_GuiControl = "IE3")
			Run, %IconEditor3%
		else if (A_GuiControl = "IE4")
			Run, %IconEditor4%
		else if (A_GuiControl = "IC")
			Run, %IconConverter%
		else if (A_GuiControl = "MSP")
			run, %mspaint%
		else if (A_GuiControl = "ql")
            {
                If FILEExist(iconpath)
                    run, %quicklook% "%iconpath%"
                else
                    Tip("Quicklook requres an iconpath to preview.")
            }
		else if (A_GuiControl = "ev15a")
			{
			; run, %everything15a% 
			if (A_Username = "CLOUDEN")
				run "%everything15a%" -s* ico: %a_space%
			Else
				run "%everything15a%" -s* ext:ico c: %a_space%
			}
        return
	}
	
	if (iconpath != "") && (A_GuiControl = "ev15a")
		{
		SplitPath, iconfilepath, iconname
		if (A_Username = "CLOUDEN")
			run "%everything15a%" -s* ico: %iconname%
		Else
			run "%everything15a%" -s* ext:ico c: %iconname%
		return
		}
		
	SplitPath, iconfilepath,,,iconfileext
	if (iconfileext != "ico")
		{
			Tooltip You can only try to edit`na .ico file from here.
			sleep 2000
			tooltip
			return
		}
	if FileExist(iconfilepath)
		{
			; msgbox ife: %iconfileext%`n`nIFP: %iconfilepath%`n`nIP: %iconpath%

		if (A_GuiControl = "IV")
			Run, %IconViewer% "%iconfilepath%"
		else if (A_GuiControl = "IE1")
			Run, %IconEditor1% "%iconfilepath%"
		else if (A_GuiControl = "IE2")
			Run, %IconEditor2% "%iconfilepath%"
		else if (A_GuiControl = "IE3")
			Run, %IconEditor3% "%iconfilepath%"
		else if (A_GuiControl = "IE4")
			Run, %IconEditor4% "%iconfilepath%"
        else if (A_GuiControl = "DV")
			Run, %DopusViewer% "%iconfilepath%"
		else if (A_GuiControl = "IC")
			Run, %IconConverter% "%iconfilepath%"
		else if (A_GuiControl = "MSP")
			run, %mspaint% "%iconfilepath%"
        else if (A_GuiControl = "ql")
            {
                If FILEExist(iconpath)
                    run, %quicklook% "%iconfilepath%"
                else
                    Tip("Quicklook requires an file path to preview.")
            }
		else if (A_GuiControl = "ev15a")
				{
					SplitPath, iconfilepath, iconname
					if (A_Username = "CLOUDEN")
						run "%everything15a%" -s* ico: %iconname%
					Else
						run "%everything15a%" -s* ext:ico c: %iconname%
					return
				}
		}
		
return
SearchforiconsinEverything:
if !FileExist(everything15a)
	{
        tooltip Everything cannot menu found!
        SetTimer, RemoveToolTip, -2700
        return
	}
gui, submit, nohide
ControlGetText, iconfilepath, Edit2, - Change Folder .Ico - ahk_class AutoHotkeyGUI,
if (iconfilepath = "")
{
if (A_Username = "CLOUDEN")
	run "%everything15a%" -s* ico: %a_space%
Else
	run "%everything15a%" -s* ext:ico c: %a_space%
}
else
{
	SplitPath, iconfilepath, iconname
if (A_Username = "CLOUDEN")
	run "%everything15a%" -s* ico: %iconname%
Else
	run "%everything15a%" -s* ext:ico c: %iconname%
}
return

RemoveTooltip:
Tooltip
return



GuiSize:
; guisize:
	If (A_EventInfo = 1) ; The window has been minimized.
		Return
	; AutoXYWH("w", "NewValue")
	; AutoXYWH("w", "Newkey")
	; AutoXYWH("y", "caningbut")
    
; GuiControl Move, NewKey, % "w" A_GuiWidth-20
; GuiControl Move, NewValue, % "w" A_GuiWidth-20
NewWidth := A_GuiWidth - 23
NewHeight := A_GuiHeight - 23
GuiControl, Move, folderpath, W%NewWidth% ;H%NewHeight%
GuiControl, Move, IconPath, W%NewWidth% ; H%NewHeight%
GuiControl, Move, IniPreview, W%NewWidth% ; H%NewHeight%
GuiControl, Move, InfoTip, W%NewWidth% ; H%NewHeight%
GuiControl, Move, ll1, W%NewWidth% ; H%NewHeight%
GuiControl, Move, ll2, W%NewWidth% ; H%NewHeight%
GuiControl, Move, ll3, W%NewWidth% ; H%NewHeight%
GuiControl, Move, ll4, W%NewWidth% ; H%NewHeight%
GuiControl, Move, ll5, W%NewWidth% ; H%NewHeight%
; Critical Off  ; Even if Critical On was never used.
; Sleep -1
Return

GuiEscape:
GuiClose:
if (ExitOnClose)
	Exitapp
else
	gui, Minimize
return
Exit:
    ExitApp
	
Reload:
ReloadCFI:
if (RememberHistory)
	RememberLastPaths()
Reload
Return

RememberWinPos() ;; function
{
    global inifile, X, Y
    WinGet, state, MinMax, - Change Folder .Ico - ahk_class AutoHotkeyGUI
    if (state = 0) ; Only save if normal (not minimized or maximized)
    {
        WinGetPos, X, Y,,, - Change Folder .Ico - ahk_class AutoHotkeyGUI
        IniWrite, %X%, %IniFile%, Settings, X
        IniWrite, %Y%, %IniFile%, Settings, Y
    }
}

RememberLastPaths() ;; function
{
    global folderpath, iconpath, inifile
    gui, submit, nohide
    if (Folderpath != "")
        iniwrite, %folderpath%, %inifile%, Settings, FolderPathOnClose
    if (iconpath != "")
        iniwrite, %iconpath%, %inifile%, Settings, IconPathOnClose
}

; return

;---------------------------------------------------------------------------


; ~F16:: ;; if dope, change folder icon v2, testing todo
; applyicontofolder: ;; iconex
; SetWindowsFolderIcon: ;; qap
; makedesktopini:
; changefoldericon:
ShowLoadFolderfromDOPUSmenu:
gosub dopeiconmenu
CoordMode, menu, client
menu, d, show,10,10
return
ddmenu:
	Menu, dd, add, Err! Dopusrt.exe not found. Click here to update its location., updatedopusrt
	Menu, dd, icon, Err! Dopusrt.exe not found. Click here to update its location., %icons%\adminrunning.ico,,32
	Menu, dd, show
return
dopeiconmenu:
if !FileExist(dopusrt)
	{
		goto ddmenu
		return
	}

Menu, d, add
Menu, d, deleteall

Menu, d, add, Change Folder Icon From A Dopus Tab, ShowLoadFolderfromDOPUSmenu 
Menu, d, icon, Change Folder Icon From A Dopus Tab, %dopus%,,%32%
Menu, d, default, Change Folder Icon From A Dopus Tab
Menu, d, add, ; line ------------------------- 
; Menu_SetModeless("changeicon")
if FileExist(dopusrt)
	gosub livedopustabs
; Menu, d, add,
; Menu, d, add,
; Menu, d, add,

if (A_Username = "CLOUDEN")
{
WinGetTitle, dopetitle, ahk_class dopus.lister ; | - Directory Opus v13 - |, 
dopetab := Regexreplace(dopetitle, " \| - Directory Opus v13 - .*", "") ;; parentdir
dopesel := regexreplace(dopetitle, ".* \| - Directory Opus v13 - \| ", "") ;; selected
; SplitPath, dopetab, tabfilename, tabdir,
; FileGetAttrib, dopetabAttr, %dopetab%
	Menu, d, add, ; line -------------------------
	; Menu, d, add, X Title Read, DoNothing
	; Menu, d, add, ; line -------------------------
Menu, d, add, Active Tab: %dopetab%, applyAtab
; Menu, d, Icon, Parent: %tabdir%\%tabfilename%, % GetFileIcon(dopetab) ;; get file icon
Menu, d, Icon, Active Tab: %dopetab%, % GetFileIcon(dopetab),,%is% ;; get file icon
	
if !FileExist(dopesel) ; if nothing is selected
	{
	; Menu, d, add, ; line -------------------------
	}
else
	{
	; SplitPath, dopesel, selfilename, seldir, selext
	FileGetAttrib, dopeselAttr, %dopesel%
	if (InStr(dopeselattr, "D"))
		{
		Menu, d, add, Selected: %dopesel%, applySel 
		Menu, d, Icon, Selected: %dopesel%, % GetFileIcon(dopesel),,%is% ;; get file icon
		; Menu, d, add, ; line -------------------------
		}
	; else
		; Menu, d, add, ; line -------------------------
	}
;--------------------------------------------------

}

return

livedopustabs:
; msgbox %temp%
dopetabs = %temp%\dopustabs.xml

; dopesel = %temp%\dopesel.xml
; dopusrt = C:\Program Files\GPSoftware\Directory Opus\dopusrt.exe

	run, %dopusrt% /info %dopetabs%`,paths`, ; %temp%, Hide
	; run, %dopusrt% /info %dopesel%`,list`,
sleep 150

GetTABSFromXML(dopetabs)
paths := GetTABSFromXML(dopetabs)

FileDelete, %dopetabs%
; Create the submenu
if (IsObject(paths)) {
    ; MsgBox, % "Submenu created with " paths.Count() " paths."

    for index, pathObj in paths {
        ; menuItem := "Path " index ": " pathObj.DisplayPath
        menuItem := pathObj.DisplayPath
		Menu, d, Add, %menuItem%, applyactivetab
        ; Menu, dope-tabs, Add, %menuItem%, OpentabsPath
		iconPath := GetFileIcon(menuitem)
        ; if FileExist(iconPath)
            ; Menu, dope-tabs, Icon, %menuItem%, %iconPath%
        Menu, d, Icon, %menuItem%, % GetFileIcon(pathObj.Path),,%is%
        MenuPath%A_Index% := pathObj.Path  ; Store paths for later access
    }
; Menu, dope, Add, Open Tabs\Folders, :dope-tabs
; menu, dope, show
} else {
	if (A_IsAdmin)
	{
	Menu, d, add, ERR! Reading Tabs. Try running script not as Admin, donothing
	Menu, d, icon, ERR! Reading Tabs. Try running script not as Admin, %icons%\adminrunning.ico,,%is%
	Menu, d, add, ; line -------------------------
	Menu, d, add, Click here to EXIT. You have to manual launch the script again., exit
	Menu, d, icon, Click here to EXIT. You have to manual launch the script again., %icons%\exitapp.ico,,%is%
	}
	else
	{
    Menu, d, add, ERR! Reading tabs. Maybe the Dope isn't open?, donothing
    Menu, d, icon, ERR! Reading tabs. Maybe the Dope isn't open?, %iconerror%,,%is%	
	}
}
return
opendopustabsmenu:
; msgbox %temp%
dopetabs = %temp%\dopustabs.xml

; dopesel = %temp%\dopesel.xml
; dopusrt = C:\Program Files\GPSoftware\Directory Opus\dopusrt.exe
	run, %dopusrt% /info %dopetabs%`,paths`, ; %temp%, Hide
	; run, %dopusrt% /info %dopesel%`,list`,
sleep 150

GetTABSFromXML(dopetabs)
paths := GetTABSFromXML(dopetabs)

FileDelete, %dopetabs%
; Create the submenu
if (IsObject(paths)) {
    ; MsgBox, % "Submenu created with " paths.Count() " paths."

    for index, pathObj in paths {
        ; menuItem := "Path " index ": " pathObj.DisplayPath
        menuItem := pathObj.DisplayPath
		menu, f, Add, %menuItem%, opendopustab
        ; Menu, dope-tabs, Add, %menuItem%, OpentabsPath
		iconPath := GetFileIcon(menuitem)
        ; if FileExist(iconPath)
            ; Menu, dope-tabs, Icon, %menuItem%, %iconPath%
        menu, f, Icon, %menuItem%, % GetFileIcon(pathObj.Path),,%is%
        MenuPath%A_Index% := pathObj.Path  ; Store paths for later access
    }
; Menu, dope, Add, Open Tabs\Folders, :dope-tabs
; menu, dope, show
} else {
	if (A_IsAdmin)
	{
	menu, f, add, ERR! Reading Tabs. Try running script not as Admin, donothing
	menu, f, icon, ERR! Reading Tabs. Try running script not as Admin, %icons%\adminrunning.ico,,%is%
	menu, f, add, ; line -------------------------
	menu, f, add, Click here to EXIT. You have to manual launch the script again., exit
	menu, f, icon, Click here to EXIT. You have to manual launch the script again., %icons%\exitapp.ico,,%is%
	}
	else
	{
    menu, f, add, ERR! Reading tabs. Maybe the Dope isn't open?, donothing
    menu, f, icon, ERR! Reading tabs. Maybe the Dope isn't open?, %iconerror%,,%is%
	}
}
return
showopenfoldermenu:
gui, submit, nohide
gosub openfoldermenu
CoordMode, menu, client
menu, f, show, 10,10
return
openfoldermenu:
menu, f, add, 
menu, f, deleteall
menu, f, add, Open Which Folder?, showopenfoldermenu
menu, f, icon, Open Which Folder?, %icons%\openfolders.ico,,%is%
menu, f, default, Open Which Folder?
menu, f, add, ; line -------------------------
if FileExist(folderpath)
	{
	menu, f, add, Working Folder: %folderpath%, openworkingfolder ; openfolderpathfolder
	; menu, f, icon, Working Folder: %folerpath%,  openfolderpathfolder ; #todo, add folder icons here
	}
if FileExist(iconpath)
	{
	SplitPath, iconpath, iconame, icodir
	menu, f, add, Icon Folder: %icodir%, openiconfolder ; openiconpathfolder
	; menu, f, icon, Icon Folder: %icodir%, ; #todo, add folder icons here
	}
if (folderpath = "" && iconpath = "")
	{
		menu, f, add, Both path fields are empty., donothing
		menu, f, icon, Both path fields are empty., %iconerror%,,%is%
		menu, f, Default, Both path fields are empty.
	}
if Fileexist(IconLibrary)
	{
	menu, f, add, ; line -------------------------
	menu, f, add, Open Icon Library`t%OpenIconLib%, OpenIconLib
	Menu, f, icon, Open Icon Library`t%OpenIconLib%, % GetFileIcon(IconLibrary),,%is%
	; menu, f, icon, Open Icon Library, OpenIconLib
	; menu, f, add, ; line -------------------------
	}
if FileExist(dopusrt)
	{
	if winexist("ahk_class dopus.lister")
		{
			menu, f, add, ; line -------------------------
			menu, f, add, Open a Dopus Tab , donothing
			menu, f, icon, Open a Dopus Tab, %dopus%,,%is%
			menu, f, add, ; line -------------------------
			gosub opendopustabsmenu
		}
	}
return
OpenIconLib:
try run %IconLibrary%
return

copyworkingfolder:
clipboard =
sleep 40
clipboard = %folderpath%
clipwait,0.5
if (clipboard != "")
{
tooltip Copied Working Folder Dir
SetTimer, RemoveToolTip, -1500
}
return

openworkingfolder:
run "%folderpath%"
return

CopyIconPath:
clipboard =
sleep 40
clipboard = %iconpath%
clipwait,0.5
if (clipboard != "")
{
tooltip Copied Icon Path
SetTimer, RemoveToolTip, -1500
}
return
openiconfolder:
try Run, %dopusrt% /cmd Go "%iconpath%" NEWTAB=deflister`,findexisting TOFRONT
catch
    Run explorer.exe /select`,"%iconpath%"
; Gui, submit, nohide
; if !Fileexist(iconpath)
; {
    ; box(folderpath " - - " iconpath )
    ; return
; run, %iconpath%
; }

; run "%icodir%" ;; old no
return

opendopustab:
run %A_ThisMenuItem%
return
GetTABSFromXML(file) {
; working keep
Global
    FileRead, xml, %file%
    if (ErrorLevel) {
        ; tooltip, Failed to read file: %file% `n`n%A_ScriptFile%`nline: %A_LineNumber%
		; SetTimer, RemoveTooltip, -2000	
        return
    }

    xmldom := ComObjCreate("MSXML2.DOMDocument.6.0") ; Create an MSXML DOMDocument object
    xmldom.async := false

    if (!xmldom.loadXML(xml)) { ; Load the XML content
        ; tooltip, Failed to load XML: %file% `n`n%A_ScriptFile%`nline: %A_LineNumber%
		; sleep 3000
		; tooltip
        return
    }
    paths := [] ; Initialize an empty array to hold the paths
    nodes := xmldom.selectNodes("//path") ; Select all <path> nodes
    Loop % nodes.length {
        node := nodes.item(A_Index - 1)
        pathValue := node.text ; Extract path text and display_path attribute
        displayPath := node.getAttribute("display_path")
        paths.Push({Path: pathValue, DisplayPath: displayPath}) ; Push both the path and its attributes to the array
    }
    return paths ; Return the array of paths
}

; Helper function to loop through COM nodes
LoopCOMNodes(nodes) {
    nodesArray := []
    if IsObject(nodes) {
        count := nodes.length
        Loop, %count% {
            nodesArray.Push(nodes.item(A_Index - 1)) ; 0-based index for COM collections
        }
    }
    return nodesArray
}



updatedopusrt:
gui, ud: new
gui, ud: color, 171717, 050505
gui, ud: font, s12 c0xBEFED3, Consolas
gui, ud: add, text, xm w500, dopusrt.exe was not found in it default location @ %A_ProgramFiles%\GPSoftware\Directory Opus\`n`nIt's needed to build this menu of open tabs.`n`nIf you have Dopus installed in custom location paste or pick the file path below to update it.

gui, ud: add, edit, xm vndrt w450,
gui, ud: add, Button, x+m gpickdrt, . . .
gui, ud: add, button, xm gapplynewdrt, &Apply New Path && Reload
gui, ud: add, button, x+m gcloseud, &Cancel
gui, ud: +AlwaysOnTop
gui, ud: show,,- Change Folder .Ico - ! Update Dopus Location
return

pickdrt:
fileselectfile, ndrtpath,1,,Select the path to dopusrt.exe,(*.exe)
GuiControl,,ndrt,%ndrtpath%
return
applynewdrt:
gui, submit, nohide
if !FileExist(ndrt)
	{
		MsgBox, Err! The path pasted does not exisit.`n`nPlease Try again.
		return
	}
else
	{
	SplitPath, ndrt, ndrtfilename, ndrtdir
	if (ndrtfilename = "dopusrt.exe")
		{
			IniWrite, %ndrt%, %inifile%, Programs, dopusrt
			IniWrite, %ndrtdir%\dopus.exe, %inifile%, Programs, dopus
			sleep 750
			reload
		}
	else if (ndrtfilename = "dopus.exe")
		{
			; MsgBox we have a winner
			IniWrite, %ndrtdir%\dopusrt.exe, %inifile%, Programs, dopusrt
			IniWrite, %ndrtdir%\dopus.exe, %inifile%, Programs, dopus
			sleep 750
			reload
		}
	else if (ndrtfilename != "dopusrt.exe" || "dopus.exe")
		{
			Msgbox, Err! This is not dopusrt.exe or dopus.exe`n`n`tPlease try again.
			return
		}
	}
; ControlGetText,drt
return
closeud:
gui, ud: destroy
return
applyAtab:
guicontrol,,folderpath, %dopetab%
goto LoadFolderPath
return
applySel:
guicontrol,,folderpath, %dopesel%
goto Loadfolderpath
return
applyactivetab:
guicontrol,,folderpath, %A_thismenuitem%
goto loadfolderpath
return
opentabspath:
tooltip %A_thismenuitem%
SetTimer, RemoveTooltip, -2000	
return


;"



;----------------------------------------------------------------------------------------------------
;----------------------------------------------------------------------------------------------------
fastsetnewicon:
gui, submit, nohide
if !Fileexist(folderpath) && !Fileexist(iconpath)
	{
        tooltip The Folder && Icons Paths Cannot Be Found.`nOperation Canceled.
        SetTimer, RemoveTooltip, -2000	
        return
	}
if (FastSetWarningSeen = "false")
	{
	MsgBox, 4148, - Change Folder .Ico - ! Fast Set, This is the only time this button will bug you.`n`nUse this button for a speedy icon change. Its Skips Conformations and only saves basic details to the desktop.ini file.`n`nIt only works with .ico files.`nAND! It will Force Windows Explorer to reload each time you use it. Then - Change Folder .Ico - will close.`n`n`nContinue...  ???
	IfMsgBox no
		return
	IfMsgBox Yes
		{
            iniwrite, true, %inifille%, Settings, FastSetWarning
            goto carryon
		}
	}
carryon:
SplitPath, iconpath,,,ext
if (ext != "ico")
	{
        tooltip This Button only works with .ico files.`nOperation Canceled
        SetTimer, RemoveTooltip, -2000	
        return
	}
AskMeToConfirmOnSave := 0
forcewindownsreload := 1
gosub SetNewIcon
sleep 1000
exitapp
return

EnableHideIco:
Gui, submit, nohide
If (CopyIcoToDest)
    GuiControl,enabled,HideLocalIco
else
    GuiControl,disabled,HideLocalIco
; guicontrolget,wantslocalico,,HideLocalIco ; wtfahk
; If (wantslocalico)    ; GuiControl,enabled,HideLocalIco ; else    ; GuiControl,disabled,HideLocalIco
return
confrimbuttons:
IfWinNotExist, ! Setting New Folder Icon
	Return
SetTimer, confrimbuttons, Off
WinActivate
ControlSetText, Button1, Don't ask again
ControlSetText, Button2, Yes
ControlSetText, Button3, No
Return
;; &apply
applyicon: ;; this is attracted to edit2 iconpath
Return

SetIcon:
SetNewIcon:  ; &set
Gui, Submit, NoHide
folderpath := RegExReplace(folderpath, "\\$") ; Ensure no trailing backslash
If !FileExist(folderpath)
{
    Box("The Folder path cannot be found!`n`nOperation canceled.",4)
    return
}
; ShowError(A_LineNumber, folderpath, IconResource, iconpath, iconfile, desktopini, iconindex) ; varcheckbox()
; SplitPath, folderpath,, dir,, drive


SplitPath, folderpath,dn,dd,de,ds,dv ; box("fp=" folderpath "`nn=" n "`nd=" d "`ne=" e "`ns=" s "`nv=" v)
if (folderpath = dv) ; if the folder path is a drive, write an .inf and copy .ico to the root, apply icon to drive ; Now "C:" will match "C:"
{
    ; if !(A_IsAdmin)
    ; {
        ; MsgBox, 262196, - Admin Elvation Requried -, Admin Elvation is reqired to set icons to hard drives. See the ** READ ME on the Drives Menu.`n`nDo you want to restart %a_scriptname% as Admin?
        ; IfMsgBox, NO
            ; Return
        ; IfMsgBox, Yes
        ; {
            ; iniwrite, 1, %inifile%, Settings, RestorePrevious
            ; iniwrite, %folderpath%, %inifile%, Settings, RestoreF
            ; iniwrite, %iconpath%, %inifile%, Settings, RestoreI
            ; sleep 300
            ; run, *RunAs "%A_scriptfullpath%"
            ; exitapp
            
        
        ; }
    ; }
    
    if (AskMeToConfirmOnSave)
    {
        MsgBox, 262212, - Set Icon to Drive -, To set an icon to a Drive the .ico file *MUST* be local on the drive. This Operation will copy ( %in% ) and create a "autorun.inf" to the root of the chosen drive && mark them as hidden.`n`nRe-Booting your system is required before the icon can be seen in the file system.`n`nAdditionally`, Should you want to manually revert this later the "autorun.inf" and copied icon will require Admin elevation to deleted.`n`nDo you want to Continue...?
        ifMsgBox, No
            return
    }
    SplitPath, iconpath,in,id,ie,is ;,v ; box("fp=" folderpath "`nn=" n "`nd=" d "`ne=" e "`ns=" s "`nv=" v)
    If !FileExist(iconpath)
    {
        Box("The Icon path cannot be found!`n`nOperation canceled.",4)
        return
    }
    if (ie != "ico")
    {
        Box("This requires the icon be an .ico file.`n`nOperation canceled.",7)
        return
    }
    localico := dv "\" in
    copytodrive := dv "\"    ; box(iconpath A_nl dv A_nl in A_nl localico) ; debug check
    filecopy,%iconpath%, %localico%,1
    localinf := dv "\autorun.inf"
    iniwrite, %in% , %localinf%, autorun, Icon
    FileSetAttrib, +H, %localinf%
    FileSetAttrib, +H, %localico%
    sleep 1000
    if (RememberHistory)
    {
        SaveFolderHistory(folderpath)
        SaveIconHistory(iconpath)
    }
    If FileExist(localinf) && FileExist(localico)
    {
        Box("Successfully save .inf and .ico to drive root.`nA Reboot is required before you will see the icon in your file system.", 5)
    }
    else
    {
        if !(A_IsAdmin)
        {
            MsgBox, 262196, - Admin Elvation Requried -, Admin Elvation is reqired to set icons to hard drives. See the ** READ ME on the Drives Menu.`n`nDo you want to restart %a_scriptname% as Admin?
            IfMsgBox, NO
                Return
            IfMsgBox, Yes
            {
                iniwrite, 1, %inifile%, Settings, RestorePrevious
                iniwrite, %folderpath%, %inifile%, Settings, RestoreF
                iniwrite, %iconpath%, %inifile%, Settings, RestoreI
                sleep 300
                run, *RunAs "%A_scriptfullpath%"
                exitapp
            }
        }
        else
        Box("There was an error creating the drive icon files!`nCheck your file paths and that you have admin access and try again.", 5)
        ; MsgBox, 4112, - Change Folder .Ico - ! Save Error, You cannot save a custom icon to the root level of a hard drive.`n`nOperation canceled., 7
    }
    return
}

;---------------------------------------------------------------------------
; Validate paths before continuing
;---------------------------------------------------------------------------
if !FileExist(folderpath) && (iconpath = "")
{
   MsgBox, 262160, - Change Folder .Ico - ! Save Error, Your missing required elements to set a new folder icon.`n`nThe folder & icons path do not exist or are empty!`n`nPlease check your paths and try again., 7
   return
}
	
if (AskMeToConfirmOnSave)
{
    ; MsgBox, 4164, - Change Folder .Ico - ! Setting New Folder Icon, This command will update the system file:`n%Desktopini%`n`nIf there is an existing desktop.ini in this directory it will be sent to the recycle bin!`n`nIt may take 10-15 seconds or up to one minute before Windows shows the new folder icon. (Forcing a Windows Explorer Reload usually helps it set faster. ** This option will close your File Explorer windows.)`n`nIf you use this tool a lot`, and don't want to see this message every time`, there is an option in the settings file to turn it off.`n  --> Set...  AskMeToConfirmOnSave= from =1 to =0.`n`nConintue .... ???

SetTimer, confrimbuttons, -100
MsgBox, 262211, ! Setting New Folder Icon, This command will update the system file:`n%Desktopini%`n`nIt may take 10-15 seconds or up to one minute before Windows shows the new folder icon. (Forcing a Windows Explorer Reload usually helps it set faster. ** This option will close your File Explorer windows.)`n`nIf you use this tool a lot`, and don't want to see this message every time`, there is an option in the settings file to turn it off.`n--> Set...  AskMeToConfirmOnSave= from =1 to =0.`n`nConintue .... ???
IfMsgBox Yes
	{
        IniWrite, 0, %inifile%, Settings, AskMeToConfirmOnSave
        global AskMeToConfirmOnSave := 0
	}
IfMsgBox No
	{
	
	}
IfMsgBox Cancel
	{
        return
	}



    ; IfMsgBox No
        ; return
}

if !FileExist(iconpath) && (iconpath != "")
{
    if (AskMeToConfirmOnSave)
    {
        MsgBox, 4148, - Change Folder .Ico - ! Save Warning, The Icon path you provided cannot be found thou is not empty. `n`nIf your saving a relative path to an icon click YES to continue.`n`nClick NO to stop and re-check your icon path.
        IfMsgBox NO
            return
    }	
}
;---------------------------------------------------------------------------
; paths are valid, carry on
;---------------------------------------------------------------------------
IniWrite, 0, %DesktopIni%, .ShellClassInfo, ConfirmFileOp



If (CopyIcoToDest)
{
    SplitPath, iconpath, n,d,e
    if (e != "ico") ;; stop operation, don't copy dlls or exe for anyone
    {
        Box("Only .ico extensions can be copied locally.`n`nOperation Cancel.",7)
        return
    }
    ;; else carry on
    localicopath := folderpath "\" n
    filecopy,%iconpath%,%folderpath%,1 ; Overwrite icon if it exits, stops errors
    Loop, 15  ; wait up to 3 seconds for the file to be copied, instead of blind sleep.
    {
        if FileExist(localicopath) 
            break ;; once the file has been copied carry on
        sleep, 200
    }
    If FileExist(localicopath)
    {
        guicontrol,,iconpath,%localicopath% ;; update gui with new path and re-sumbit
        if (HideLocalIco)
            FileSetAttrib, +H, %localicopath%
        ;; should i uncheck the boxes here, least the gui gets stuck in a submit loop? OR use Goto to bypass
        Gui,submit,nohide ;; re-sumbit to the updated with the local ico path
        goto SetIconCarryOn
    }
    else
    {
        Box("There was an error copying the .ico to the destination folder!`nIf this folder is protected try running as Admin.`n`nOperation Canceled. Please Try Again.",10)
        return    
    }
    return
}
SetIconCarryOn:
if FileExist(desktopini)
{
    ; filecopy, %desktopini%,  #todo, make a back up rather than delete
    iniread, oldinfotip, %desktopini%, .ShellClassInfo, Infotip
    iniread, oldIconfile, %desktopini%, .ShellClassInfo, IconFile
    iniread, IF_IconIndex, %desktopini%, .ShellClassInfo, IconIndex, 0
    ; iniread, oldviewstate, %desktopini%, ViewState ;;     ; msgbox oldviewstate: %oldviewstate%
    ; if (oldviewstate != "") ;; the old view state need not be re-written if the dtini is not deleted per aislop
        ; iniwrite, %oldviewstate%, %desktopini%, ViewState,
    ; if (oldinfotip != "")
    ; {    ; msgbox oldtip: %oldinfotip%

        ; if (oldinfotip = "ERROR")
        ; {
            ; IniWrite, %a_space%, %DesktopIni%, .ShellClassInfo, InfoTip
        ; }
        ; else
        ; {
            ; IniWrite, %oldinfotip%, %desktopini%, .ShellClassInfo, InfoTip
        ; }
    ; }
    
    IniRead, OLDShellInfo, %desktopini%, .ShellClassInfo ;; read the whole section, append it to a new-Renamed Section
    if (OLDShellInfo != "ERROR")
        FileAppend, `n`n[.OLD.ShellClassInfo-%A_now%]`n%OLDShellInfo%, %desktopini%
    

    inidelete, IconIndex, %Desktopini%, .ShellClassInfo    ; auto delete IconIndex as its an old vista format thats not used anymore, its preserved in the [OLD.BAK] ▲ it may interfere
    
    ;; old AISlop, oktd ▼
    ; FileRecycle, %desktopini%, ;; if i use iniwrite below i don't this the the d.ini needs to be delelted, AND i could back up old setting in their own section right here., then this ai slop doesn't even need be be here ... if (oldinfotip != "") OR if (oldviewstate != "")
    ;; filedelete was suggest by ai, now that i know ai is retarted, i don't think  the file needs to be deleted. using iniwrite will simply overwrite the parts need to set an icon, furthermore, if the .ShellClassInfo section could be copied to [OLD.ShellClassInfo]
    ; sleep 100
}

If (CopyIcoToDest)
    iconpath := n ;; if coping an .ico to a dir use relative path, eg nameonly 

if (changenumber) ;; this is main iniwrite section
{
    iniwrite, %iconpath%`,%iconindex%, %desktopini%, .ShellClassInfo, IconResource
}
else
{
    iniwrite, %iconpath%`,0 , %desktopini%, .ShellClassInfo, IconResource
}



if (allowTTB) ;; if addeding new infotip
{
    ; msgbox get the v.infotip`n`n %infotip%
    iniwrite, %infotip%, %desktopini%, .ShellClassInfo, Infotip
}

	

FileSetAttrib, +R, %folderpath%, 2
FileSetAttrib, +H+S, %DesktopIni%

; iniwrite, %iconpath%, %desktopini%, .ShellClassInfo, IconResource
; IniWrite, 0, %DesktopIni%, .ShellClassInfo, ConfirmFileOp


;------------------------- ;; extras
if (RememberHistory)
{
    SaveFolderHistory(folderpath)
    If !FileExist(iconpath)
    {
        ; box(iconpath)
        checkrelative := folderpath "\" iconpath
        ; box(checkrelative)
        If FileExist(checkrelative)
            iconpath := checkrelative
    }
        ; box(checkrelative A_nl iconpath)
    
    SaveIconHistory(iconpath)
}

if (applytoallsubs)
{
    ; SetFolderIcons(rootFolder, iconPath)
    sleep 200
    SetIconALLFOLDERS(folderpath, desktopini)
}
if (forcewindownsreload) ;; force windows to relaod
{
    sleep 200
    gosub ForceWindowExplorerReload	
}
; (Continue applying the new icon functionality here)
; gosub cleanupsavevars
sleep 200
gosub loadFolderPath
gosub PreviewIcon
Return


cleanupsavevars:
oldinfotip := ""
oldIconfile := ""
IF_IconIndex := ""
oldviewstate := ""
return

varcheckbox()
{
    MsgBox, 262144, Debug Check %A_scriptname%, dtini:  %desktopini%`n`nFP: %folderpath%`n`nIP: %iconpath% `n`nthis is what the output in desktop.ini should looke like...`nIconResource=%IconResource% : read from exsiting inis`n`n + vChangeNumber: `,%changenumber%   ---   IconIndex= %IconIndex% `,`n`nInfoTip- vallowTTB: %allowTTB% `, vInfoTip: %infotip%`n`n`nExtras ...`nForce apply now vforcewindownsreload: %forcewindownsreload% `n apply all subs vapplytoallsubs: %applytoallsubs%
}


Deletedesktopini: ;;; from qap todo for reset folder icon
If FileExist(ActiveARinf)
{
    MsgBox, 262196, ?? Reset-Delete Drive Icon, This will delete both the autorun.inf and .ico on drive %folderpath% to the Recycle Bin.`n`nNote that you will still see the icon on your system until you have Rebooted your computer.`n`nContinue?
    IfMsgBox, No
        Return
    FileRecycle,%activearinf% 
    filerecycle,%iconpath%
    sleep 1500
    If (FileExist(ActiveARinf) || fileexist(iconpath))
    {
        MsgBox, 262164, ?? Delete Fail, The assocaited file were not removed. Admin access is required.`n`nDo you want to Restart\Run as Administator and try again?
        IfMsgBox, No
            Return
        IfMsgBox, Yes
        {
            iniread, current_autoloadstatus, %inifile%, Settings, OnStartUp_AutoLoadLastFolder
            iniwrite, %current_autoloadstatus%, %inifile%, Settings, ResetFlag
            iniwrite, 1, %inifile%, Settings, OnStartUp_AutoLoadLastFolder
            IniWrite, %FolderPath%, %inifile%, Settings, FolderPathOnClose
            IniWrite, %IconPath%, %inifile%, Settings, IconPathOnClose
            sleep 400
            gosub RunAsAdmin
        
        }
    }
    else
    {
        MsgBox, 262208, Success!, The associated files for this drive icon have removed.`n`nA reboot is required before the drive icon reverts back to windows default.,8
        gosub LoadFolderPath
    
    }
    ; try, run, notepad++.exe "%ActiveARinf%"
    ; catch
    ; try, run, notepad.exe  "%ActiveARinf%"
    return
}
if !Fileexist(desktopini)
	{
        tooltip There's No desktop.ini here to delete.
        SetTimer, RemoveTooltip, -2000	
        return
	}
; if (AskMeToConfirmOnSave)
		; {
			
			; MsgBox, 4148, - Change Folder .Ico - ! Delete Warning, You are deleting a system file:`n%desktopini%`n`nThis will reset the icon and any other settings in it. This is not recommend for Windows Actual system folders.`n`nContinue... ??? 
			; IfMsgBox NO
				; return

SetTimer, deletedesktopinibuttons, -50
MsgBox, 262451,  - Change Folder .Ico - ! Delete Warning,  You are deleting a system file:`n%desktopini%`n`nThis will reset the icon and any other settings in it. This is not recommend for Windows system folders.`n`n* Select *Delete All* to remove all desktop.ini's in this folder tree. -- You should only do this if you applied a custom icon to all subfolders.`n`nContinue... ???
IfMsgBox Yes ; delete all
	{
		Gosub DeleteAllINIs
		gosub loadFolderPath
	}
IfMsgBox No ; delete one, active folder
	{
		FileRecycle, %desktopini%
		FileSetAttrib, -R, %folderpath%, 2
		gosub loadFolderPath
	}
IfMsgBox Cancel
	{
		return
	}

Return

; }
		
; FileRecycle, %desktopini%
; FileSetAttrib, -R, %folderpath%, 2
gosub loadFolderPath
return

DeleteOneINI:
FileRecycle, %desktopini%
FileSetAttrib, -R, %folderpath%, 2
gosub loadFolderPath
return

DeleteAllINIs:
RecycleALLDesktopINIs(folderpath)
return

deletedesktopinibuttons:
IfWinNotExist,  - Change Folder .Ico - ! Delete Warning
	Return
SetTimer, deletedesktopinibuttons, Off
WinActivate
ControlSetText, Button1, *Delete &All*
ControlSetText, Button2, &Delete
ControlSetText, Button3, &No
Return


;--------------------------------------------------
SetIconALLFOLDERS(folder, desktopini)    ;; Function: Copy existing desktop.ini to all subfolders
{

    if !FileExist(desktopini)    ; Ensure the source desktop.ini exists before proceeding
    {
        MsgBox, 16, Error, The source desktop.ini file does not exist!`n`nOperation Canceled.
        return
    }
   
	Loop, %folder%\*, 2, 1  ; The "1" makes it search all subdirectories    ; Loop, %folder%\*, 2 ; Loop through all subfolders
    {
        targetDesktopIni := A_LoopFileFullPath "\desktop.ini"
        FileCopy, %desktopini%, %targetDesktopIni%, 1  ; 1= Overwrite existing ini ; Copy desktop.ini to each subfolder
        FileSetAttrib, +SH, %targetDesktopIni%    ; Apply necessary attributes  ; Hide + System for desktop.ini
        FileSetAttrib, +R, %A_LoopFileFullPath%  ; Read-only for the folder
		sleep 10
    }
}

RecycleALLDesktopINIs(folder)   ;; Function: Recycle all desktop.ini files in subfolders and remove +R attribute from folders
{
	;; usage RecycleALLDesktopINIs("D:\MyCustomFolders")
    Loop, Files, %folder%\desktop.ini, R  ; R = recursive
    {
        FileRecycle, %A_LoopFileFullPath%
        Sleep, 10

        SplitPath, A_LoopFileFullPath, , folderPath
        FileSetAttrib, -R, %folderPath%  ; Remove Read-only from the folder
        Sleep, 10
    }
}

/*

SetIconALLFOLDERS(folder, desktopini)  ;; Function: Copy existing desktop.ini to all subfolders -OG-
{
    ; Ensure the source desktop.ini exists before proceeding
    if !FileExist(desktopini)
    {
        MsgBox, 16, Error, The source desktop.ini file does not exist!`n`nOperation canceled.
        return
    }

    ; Loop through all subfolders and copy desktop.ini into each one
    Loop, %folder%\*, 2
    {
        targetDesktopIni := A_LoopFileFullPath . "\desktop.ini"

        ; Copy desktop.ini from the source folder to the subfolder
        FileCopy, %desktopini%, %targetDesktopIni%, 1  ; Overwrite if exists

        ; Set attributes for desktop.ini and the folder
        FileSetAttrib, +SH, %targetDesktopIni%  ; Hide + System for desktop.ini
        FileSetAttrib, +R, %A_LoopFileFullPath%  ; Read-only for the folder

        ; Debugging message (optional)
        MsgBox, Copied %desktopini% to %targetDesktopIni%
		        ; Force Windows to refresh the folder icon by setting it as a system folder
        ; FileSetAttrib, +S, %A_LoopFileFullPath%  

        ; Debug message (optional)
        ; MsgBox, Copied %desktopini% to %targetDesktopIni%
    }
    
    sleep 200
	
    ; Run, ie4uinit.exe -show    ; Force Refresh Windows Explorer to apply the changes (moved this into its own optional fucntion\label)
    ; Run, explorer.exe /n`,%folder%  ; Open the folder to force icon update
} 

*/

Setfoldericonsinallsubs: ; gpt, not being used atm but is good working option.
;; ** I've only texted this with `.ico` files, use caution if your wanting to set an icon from a `.dll` or `.exe`
; rootFolder := "C:\Users\CLOUDEN\test 1" ; Change this to your desired root folder
; iconPath := "X:\XI\vs code icons ico\check white file_type_light_testcafe_32x32.ico" ; Change this to your desired icon file   \Documents\AutoHotkey

FileSelectFolder, rootFolder, *c:\Users\%a_username%,6,Select A Folder that you want to set a custom Icon to...
if !FileExist(rootfolder)
	{
	tooltip, ERR! @ Line:  %A_LineNumber% -- %A_scriptname%`n`nFolder Doesn't Exist! Opration Canceled.
	SetTimer, RemoveTooltip, -2000	
	return	
	}

FileSelectFile, iconpath, 1, *%A_MyDocuments%, Select a Icon.ico File.,
if ErrorLevel
{
;; todo, expand error check for acceptable icon types.
tooltip, Err! A line:  %A_LineNumber% -- %A_scriptname%`n`nA Icon File Must Be Selected! Operation Canceled.
SetTimer, RemoveTooltip, -2000	
return	
}

SetFolderIcons(rootFolder, iconPath)
    ; Refresh Windows Explorer to apply changes
	RunWait, ie4uinit.exe -show
	RunWait, taskkill /F /IM explorer.exe
	sleep 1000
    Run, explorer.exe
	
return

SetFolderIcons(folder, icon) ;; () ;; Function, set folder icons through all subfolders
{
; static Desktopinifile
    ; Desktopini := folderpath "\desktop.ini"
    
    ; Write desktop.ini with icon settings
    ; FileDelete, %Desktopinifile% ; Ensure clean overwrite
    ; FileRecycle, %Desktopinifile% ; Ensure clean overwrite
    FileAppend, 
    (
    [.ShellClassInfo]
    IconResource=%iconpath%,0
    ), %Desktopinifile%

    ; Make folder read-only and desktop.ini hidden/system
    FileSetAttrib, +R, %folder%
    FileSetAttrib, +SH, %Desktopinifile%

    ; Loop through all subfolders
    Loop, %folder%\*, 2
        {
            SetFolderIcons(A_LoopFileFullPath, icon)
		}
	
	sleep 200
}


ForceWindowExplorerReload:
forcewinreload:
	RunWait, ie4uinit.exe -show
	RunWait, taskkill /F /IM explorer.exe
	sleep 750
    Run, explorer.exe
return
;---------------------------------------------------------------------------
;---------------------------------------------------------------------------
;----------0-----------------------------------------------------------------


ListLinesx() ;; function
{
	global debugonfolderload, debugoniconpreview, debugonstartup
listLines
; sleep 500
; WinMove, A, , 2035, 1281, 1080, 720
return
} 

AboutMessage:
aboutbox1 = 
( 

Description: A Quick and Simple AutoHotkey GUI for applying a Icon to a Folder, with options for apply the icon to a full folder tree & InfoTips.

#1 - Provide a folder path 1st in the top edit field. This should be loaded first! As it will look for an existing desktop.ini, if found it read and load the content into the gui.

#2 - Then provide an icon file path in the 2nd edit field. Which will set, or overwrite, the IconResource key into a new or existing desktop.ini file upon applying.  E.g. ...

[.ShellClassInfo]
IconResource=C:\Path to your\icon\file.ico,0

*** .ICO files are STRONGLY recommend with this tool! ***

Other file types can and will work such as .dlls, .exes or .icls ...
BUT! Windows requires additional icon index definitions that I won't be fully implementing or testing here. I'm going for ease, speed and simplity with this tool making the .ico format optimal!

You can read more about desktop.ini files here...
https://hwiegman.home.xs4all.nl/desktopini.html
and more about windows icons.dll's here...
https://www.digitalcitizen.life/where-find-most-windows-10s-native-icons/


This Script was written and testing on...
Windows 10 using AutoHotkey v1.1.37+
First Release.... v.2025.03.06 
Last Update..... %version%


Click YES to visit this apps Github page for more info.
Click NO to carry on.



)
MsgBox, 262148, - Change Folder .Ico - ? About ?, %aboutbox1%
; MsgBox, 262147, , %aboutbox1% , ; #todo make this yes or no box
IfMsgBox Yes
	Run %githuburl%
IfMsgBox No
	gosub DoNothing
IfMsgBox Cancel
	gosub DoNothing
IfMsgBox Timeout
	gosub DoNothing
return






DMToggle:
If (DarkMode)
{
    DarkMode := false
    ; DarkMenu(3) ; Set to ForceLight
    iniwrite, 0, %inifile%, settings, DarkMode
    tooltip Dark Mode OFF! ;`nA Reload is required to change GUI Theme.
}
else
{
    DarkMode := true
    ; DarkMenu(2) ; Set to ForceDark
    iniwrite, 1, %inifile%, settings, DarkMode
    tooltip Dark Mode ON! ;`nA Reload is required to change GUI Theme.
}
if (folderpath != "")
{
    iniwrite, 1, %inifile%, Settings, RestorePrevious
    iniwrite, %folderpath%, %inifile%, Settings, RestoreF
    iniwrite, %iconpath%, %inifile%, Settings, RestoreI
}
SetTimer, RemoveToolTip, -3000
sleep 300
gosub ReloadCFI
return

RunAsAdmin:
if !(A_IsAdmin)
{
    Run *RunAs "%A_ScriptFullPath%" ; Relaunch script as admin
    ExitApp
}
return

warnadmin:
if (A_IsAdmin)
{
	MsgBox, 4420, Running As Admin, If you don't want this script running as Admin any longer you must Exit it completely and Re-Run it.`n`nWould you like to EXIT\QUIT now?`n`nYou have to Restart it Manually afterward.`n`nYES = KILL`nNO = Continue as Admin, 30
	IfMsgBox Yes
	{
		; iniwrite, 0, %inifile%, Settings, StartAsAdmin
		sleep 750
		exitapp
	}
	IfMsgBox No
		return
	IfMsgBox timeout
		return
}
return







; oktd, noting using installer anymore.
;---------------------------------------------------------------------------
;---------------------------------------------------------------------------
;---------------------------------------------------------------------------
checkinstalledicons:
installicons:

return

makeini:
fileappend,
(
[Settings]
;; Are you sure nag boxes?
AskMeToConfirmOnSave=1
;; Auto loads folder path from the clip when starting the app
AutoCheckClipboard4Path=0
DarkMode=1
; 1 = ExitApp, 0 = Minimize to taskbar
ExitOnClose=1
; ▼ This will force windows explore to restart **every time** you assign and icon change! if you use file explorer as your file manager it recommended to keep this turned off.
ForceApplyNOW=0
HideTooltips=0
; missing icons path in menus will be marked in menus, you can set your own icon here.
iconerror=%A_ScriptDir%\Icons\iconerror.ico
;; Have a collection of icons? set it here and file picker will open to it from the IconPath field
IconLibrary=C:\Users\%A_UserName%\Pictures
;; Save & Makes a menu of folders & icons used in the app.
RememberHistory=1
History_NumberOfItemsToRemember=30
;; on app startup... 0 = start empty, 1 = restore the last active folder & icon. this is ignore unless RememberHistory=1 is turn on
OnStartUp_AutoLoadLastFolder=0
;; 0 = Start centred on screen, 1 = Start where it was last closed
RememberWindowPos=1
;; Assign icon viewing\editing\tools in the [Programs] section below to populate this bar
ShowAppBar=1
;; show a classic menu bar, picture button menus are duplicated here.
ShowMenuBar=0
;; Always run as admin on start up, rarely necessary. Needed for changing system folders at your own risk!
StartAsAdmin=0
;; Always start the app pinned above other windows, good for drag & drop.
StartOnTop=1
;; GUI Font
Font=Consolas
;; Icon sizes in menus. Windows default is 16~20 depending on DPI Scaling. 
MenuIconSize=24
;; Sticky Settings copying and hiding a.ico file to active folderpath.
CopyIcoToDest=0
HideLocalIco=0
AutoClearTooltips=1
;; Timer is in Milliseconds, eg 5000 = 5 secs
ClearToolTipTimer=5000
;; Remembered window position 
X=500
Y=500
;; you should only turn these on if creating an *issue report* on github. these can help the dev find his Oops
ShowAHKErrorWarnings=0
FastSetWarningSeen=false
;---------------------------------------------------------------------------

[Global_Hotkeys]
Reload= | Reload Change Folder .Ico
Show_CFICO_GUI= | Activate Change Folder .Ico
;; For a full list of AutoHotkey's {Special_KeyNames} such as ESC, Home, Mouse Buttons, Space etc... and their uses visit the Docs page for reference.  https://www.autohotkey.com/docs/v1/KeyList.htm
;; You Can Change or Removed Hotkeys Here...
;; ** hotkey layout...
;; labelName= (set your hotkey here) | Description for the live hotkey menu
;; LabelName=  <-- DO NOT CHANGE anything before the "="
;; Set, or remove, the hotkey between the "=" & "|"

;; AutoHotkey's Modifier Symbols are... 
;; Ctrl = ^  ; Shift = + ; Win = # ; Alt = !
[Hotkeys]
AboutMessage=^F1 | About Overview Message
AlwaysOnTopToggle=^P | Pin - UnPin from Top
Browse4FOLDERtoLoad=^O | Browse for a Folder
Browse4ICONtoLoad=^I | Browse for a Icon
CheckClipboard4FOLDER=^+V | Paste && Load Folder Path from Clipboard
CheckClipboard4ICO=^!V | Paste && Preview Icon Path from Clipboard
DMToggle=^F3 | Toggle Dark-Light Mode Menus
EditCFISettings=^F11 | Editing Settings File
Exit=!F4 | Quit \ Exit Change Folder .Ico
ForceWindowExplorerReload=^+#END | Force Windows Explorer to Reload
LoadFolderPath=^Enter | Load Folder Path Field
PreviewIcon=+Enter | Preview Icon
OpenScriptDir=^+D | Open App Directory
OpenIconLib=^!I | Open Icon Lib (if set)
ReloadCFI=F5 | Reload Change Folder .Ico
RunAsAdmin=^!#F1 | Run as Administrator
SearchforiconsinEverything= ^E | Search for Icons in Everything
SetNewIcon=^S | Set New Folder Icon
FastSetNewIcon=!+F | Set New Folder Icon && Exit App
SaveFolderToHistory=^+F | Save Working Folder Path to History
SaveIcontoHistory=^+I | Save Working Icon path to History
ShowFolderHistoryMenu=^H | Show Menu - History
ShowHotkeyMenu=F1 | Show Menu - Quick Actions && Hotkeys
ShowLoadFolderfromDOPUSmenu=^D | Show Menu - Load Folder from Dopus Tabs
ShowOpenFolderMenu=^G | Show Menu - Open Folder in File Manager
ShowSettingsMenu=F11 | Show Menu - Settings
togToolTips=^F8 | Toggle GUI Tooltips
VisitGithubWebpage=^+F1 | Visit Change Folder .Ico Webpage (Github)
;---------------------------------------------------------------------------
[Programs]
dopus=C:\Program Files\GPSoftware\Directory Opus\dopus.exe
dopusrt=C:\Program Files\GPSoftware\Directory Opus\dopusrt.exe
TextEditor=C:\Program Files\Notepad++\notepad++.exe
IniTextEditor=X:\PFP\Notepad4\Notepad4.exe
;; Your Fav Text editor for opening desktop.ini & autorun.inf's with
;; For the Apps Launcher Bar... Replace these example programs paths with your own Favorite apps. use the full path.
;; These buttons will not appear on the gui until your set them here.
IconViewer=C:\Program Files\XnViewMP\xnviewmp.exe
IconEditor1=X:\PFP\icofx3\icofx3.exe
IconEditor2=C:\Program Files\Adobe\Adobe Photoshop CS6 (64 Bit)\Photoshop.exe
IconEditor3=C:\Program Files\Adobe\Adobe Photoshop 2020\photoshop.exe
IconEditor4=C:\Program Files\GIMP 3\bin\gimp-3.exe
EveryThing15a=C:\Program Files\Everything 1.5a\Everything.exe
IconConverter=C:\Program Files\XnConvert\xnconvert.exe
DopusViewer=C:\Program Files\GPSoftware\Directory Opus\d8viewer.exe
QuickLook=C:\Users\%A_Username%\AppData\Local\Programs\QuickLook\QuickLook.exe
IconMixer=C:\Program Files (x86)\Folder Creator\FolderCreator.exe
;; additional icon editing\extracting software... these are not related to the icon bar (supprot for them might be intraged in furture editions.)
;; even if there are duplicates put the path in the paths ▲ above this comment.
;; "`%`%Link$"=Paid Software, the other are free or shareware, and there are more, these are just a few I've found help in creating this tool and my icon library. these links are not affiliated in anyway.
IconsExtnir=X:\PFP\SysUtils\NirSoft\iconsext.exe
IconsExtLink=https://www.nirsoft.net/utils/iconsext.html
IconExplorer=X:\PFP\SysUtils\MiTeC\IconExplorer.exe
IconExplorerlink=https://www.mitec.cz/iconex.html
IcoFx=X:\PFP\icofx3\icofx3.exe
icofxLink$=https://icofx.ro
RWIconEditor=X:\PFP\IconEditor-RealWorld\RWIconEditor.exe
RWIconEditorLink=https://www.rw-designer.com/3D_icon_editor.php
FolderCreator=C:\Program Files (x86)\Folder Creator\FolderCreator.exe
FolderCreatorLink$=https://foldercreator.com
;-------------------------

;; Additionally notes, Passing Parameters to ChangeFolderIcon.exe. You can send any file\folder to CFI. A folder will be loaded into the FolderPath. ".ico" files will be placed into the IconPath Field. Any other file that not .ico will be split to it parent directory which will be placed in the Folderpath. eg...

;; Run, "X:\Path To\ChangeFolderIcon.exe" "C:\users\`%UserProfile`%\Documents\My Folder" = would put this folder in FolderPath
;; Run, "X:\Path To\ChangeFolderIcon.exe" "C:\users\`%UserProfile`%\Documents\My Folder\My Icon.ico" = would put the .ico in IconPath
;; Run, "X:\Path To\ChangeFolderIcon.exe" "C:\users\`%UserProfile`%\Documents\My Folder\This File.TXT" = will ingore "\This File.TXT" and put the parent folder in FolderPath




), %inifile%
sleep 2000
Return

Makechangelog:
changelogbody =
(
Changelog Symbols Key: + NEW|ADDED, - REMOVED, ! FIXED, * CHANGED, # TODO, $ ISSUE|BROKEN

# on the dev's wishlist still ...
- [ ] Re-work SetIconToWholeFolderTree() to backup exisiting desktop.ini's at the moment they Recycled and replaced
- [ ] allow editing existing desktop.ini files directly in the app from the edit field?
- [ ] fix DPI scaling on buttons that i have icons. built on 4k+125`% scaling, at 100`% theyre off center
- [ ] add errorlevel and leading "\" backslash to loading relative path icons, 10`% time theyre seen but not loaded until hitting the preview.ico button
- [ ] create readme.md documentation as this pet project has grown a lot more than i anticipated.
- [ ] integrate the apps bar into the context menu ?
- [ ] Clean up duplicate entries in tray menu from envclass() and local static items.
- [ ] log all changes made the the app to a local text file (in addition the history's menu)

;------------------------- v.2026.04.10

>[!IMPORTANT]
> ***BREAKING CHANGES!*** The File Name and Path Has Changed! 
> ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
> For users whom passing parama's through any CLI you should update your scripts\buttons.
> Old Name = .\Change Folder ICO\Change Folder ICO.exe
> NEW NAME = .\ChangeFolderIcon\ChangeFolderIcon.exe
>
> ***Addiontally*** The Name of the Settings.ini has Changed
> ‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
> There's a few new items in the [programs] sections. otherwise this exe will make a new .ini file. to keep your settings you can manually copy over the sections from you old file.
> Old Name = .\Change Folder ICO.`%ext`%-SETTINGS.ini
> NEW NAME = .\ChangeFolderIcon.ini 

!*- AI:Slop Code Clean Up!
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
- Completely removed the make shift "installer". The app is still portable as it was before, download the zip, place anywhere that's not in a system directory, uncompress and run it from the folder it was zipped in. Simple. - also removed 1st run MsgBox.

!* desktop.ini files are no longer deleted and re-created. The changed icon values are updated directly.
+ Additionally... the existing data in a exising desktop.ini file is now copied & back up to its own section
    eg, [.OLD.ShellClassInfo-Timestamp] = [.OLD.ShellClassInfo-20260330110152].

    **Note** There is no "Undo" in this app but now you can manually revert changes via delete the active [.ShellClassInfo] heading while rename the backed up section to match active active heading.
    
++ added a CleanUP button that will delete the sections starting ".OLD." from the active desktop.ini should you want to remove the backup history from the file.

   #Todo NOTE! Setting or removing an icon to an entire directory tree has *NOT been re-worked yet!* This will still recycle and\or replace all desktop.ini's in the given folder tree. 



+!* Gui Improvements
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
!* edit fields and the gui are now re-sizable on the width axis.
+ Added `Font=` to [Settings], the default is Consolas, mono-spaced. $ gui buttons have been tweaked for custom fonts thou newline clipping my occur with larger fonts.
! improved DarkMode support on edit inputs boxes, scroll bar are now dark in darkmod
+ improved\added a function to save window position when moved rather than just saving it when closed.
* converted hidden pictures for active desktop.ini options to disabled\enabled buttons

+!* MENU Improvements
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
* Separated the bulked History Menu into individual Folder && Icons Menus respectively
+ The Numumber is history items to remember is now definable in the ini through [Settings]>History_NumberOfItemsToRemember=30 . The hardcoded app default is 30. you can adjust up\down here.
+ added [Settings]>MenuIconSize=24. This will allow you change the icon size (in Pixels) on the menus, windows default to 16 or 20 px depending on dpi scalling. 
* Improved icon rendering for scaled icons larger than windows defaults
+ added a live folder menu button that will place the selected file into the iconpath for quick .\relative\paths assignments. This live folder menu only shows applicable extensions which are .ico, .exe, .dll, and .icl. Its also shows .ini files as clicking a desktop.ini file will open it so you can edit it directly in a text edtior.
*+ cleaned-up and added logic improvements to the right-click context menu
+ added sub-menus to the context menu for the system tray, settings, and live hotkeys menus.
! Fixed an error for "Open Current Icon Path" menu item opening to wrong folder
! improved\fixed loading previews from relative sources
+ the tray menu now contains more options that are __Class spill overs from my other software project. $ (possible bugs) some new tray menu items might not work without the required ahk script file they're calling. however these should, hopefully, remain hidden to anyone but the dev.

+!* 3rd Party App Support
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
+ added support for Dopus Image Viewer to the apps bar.
+ added support for [QuickLook](https://github.com/QL-Win/QuickLook) to the apps bar
+ added support for [FolderCreator $](https://foldercreator.com) to the apps bar. $ this is Paid program but a fun one for graphic enthusiasts.

+# add\ing support for a couple freeware extraction program for grabbing icons out of exe,dll,icl files. eg, IconExt and IconExplorer *(they're old looking but work great)
    IconsExt=X:\PFP\SysUtils\NirSoft\iconsext.exe
    IconsExtLink=https://www.nirsoft.net/utils/iconsext.html
    IconExplorer=X:\PFP\SysUtils\MiTeC\IconExplorer.exe
    IconExplorerlink=https://www.mitec.cz/iconex.html

+ Added a menu item for dopus users which will copy the xml.dcf to your clipboard for quick and easy pasting on toolbars\menus.

+!* Other Changes
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
-* (partly) Removed the limitation for only saving .ico file through the iconpath edit field, **it now always saving `.exe`'s as an icon.** $$ there might a couple lingering bugs from this change.
    ~~$# still have not implated a iconindex override here. if you use an .exe path it will default to `,0` for the icon number. ** you can use the Edit Desktop.ini button\menu item to make manual overrides.~~
+ added Support for picking a icon index # via Windows "Change Icon" dialog box for .exe, .dll and .icl files

+ added checkbox options to the gui to - [ ] Copy .ico to Dest && - [ ] Hide Copied .ico. This is limited to .ico files, it will copy the file to the folder you're setting it, set the icon as relative then hide the icon if the 2nd is checked.
+ added [Settings]>OnStartUp_AutoLoadLastFolder=0 , 0=off (by default) starts with and empty gui, 1=Restores the last folder that was in the Folder when exiting the app

+ OnExit Func() to delete %temp%\~iconpreview.ico|.png and clear allocated memory from previewing icons

! Toggling between Light<>Dark Modes forces the app to reload, it now automatically remembers and reloads the active folderpath.

+ Added description\comments above most settings in the ChangeFolderIcon.ini 

! Fix errors that remove trailing "\" backslash from folderpath field
;--------------------------------------------------------------------------- 

+++ You Can Assign Icons to Hard Drives!
‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾‾
+ Added Options for Setting Icons to Hard Drives!! A button has been added that will show a menu of Fixed & Removable HDDs\SDDs on your system. Select the drive from drop down and pick an .ico file ONLY.

$$ This requires that the app be running as Admin. See note below and\or in the menu.

>[!IMPORTANT]
> - Considerations when Setting an Icon to Hard Drive -
> 
> To Set Drive Icons the app needs to be running as Admin.
> 
> To set an icon to a Drive the .ico file *MUST* be local on the drive. Thus this Operation will **Copy** the icon and create a autorun.inf file to the root of the chosen drive. eg, C:\autorun.inf & C:\Your Icon.ico - (Which Requires Admin Access). Some External drive do not requre admin access, the app will try to Copy & Create the files first, if it can't it will as you if you want to run as admin.
> 
> Re-Booting your system is required before the icon will be seen by Windows. *NOTE* Some Windows 11 PCs running a NPU might ignore the custom icon, because Windows is a pain like that.
> 
> Additionally, Should you want to manually revert this later the autorun.inf and copied icon will require Admin elevation to deleted. From the C:\ drive at least. again, some external drive will do so without elevation.
> 
> You've been informed!
> 
> On a side note I, the dev, have 8+ HDDs\SDDs in my system and have set custom icons to each one without issue. Plus a bunch of external drives as well.


;------------------------- v.2025.10.01

! Fixed an Error where paramaters being sent by dopus were causing errors when sent with quotes

* Code Cleaned up & condensed. There's now only on gui shareing both dark & light mode settings.

;------------------------- v.2025.09.30

++ added the ability to send a directory to the script as a parameter without messing with your clipboard! 
    ++* this is great option for Dopus users! if you have a button that lauches the program via dopus you can update the cmd, remove **Clipboard COPYNAMES=unc** line and replace it this single line... ***@async:"X:\the path to\Change Folder ICO\Change Folder ICO.exe" {filepath}***

    [!NOTE!] The *AutoCheckClipboardOnStart* is still an option as it is very handy.
    
! Fixed\Updated support for Everything 1.5a as they've change their file names in recent updates. 

*+ The GUI now automatically reloads when changing bewtween Light & Dark Modes

;------------------------- v.2025.09.28

! Fixed Custom IconError= Icon not being seen when set in the .ini

;------------------------- v.2025.05.31

++ Added drag-and-drop capability to the gui! .ico files will automatically be loaded into the icon path field. folders ( or any other file that's not an ico ) will be split at the last Directory and loaded into the folder field. 

    [!NOTE!] Drag-n-Drop only works on the Compiled Change Folder Ico.exe, it's a limiation of AHK that this will not work when running from an .ahk file.

! fixed copy Folder & Icons paths options on the GUI Right-Click menu

+ added quick actions & Hotkeys as a sub-menu to the GUI Right-Click menu

+! added an option to **Delete All** desktop.ini's in folder tree. this should only be use if you used this app to apply the same icons to all subfolders in a folder tree


;------------------------- v.2025.04.22

+ added a right-click context menu to gui.

! fixed an error accessing MSpaint.exe between win 10 & win 11

! changed\fixed some windows.dll icons on to gui to local so they'd between windows versions

! fixed setting the wrong workingDir that was creating the ini and changelog file in its parentDir

* changed the Start Pinned to top checkbox to an Icon

;------------------------- v.2025.03.27

* GUI Updates...
*+ added icons to all GUI buttons, because... ICONS!
* changed all buttons to darkmode.
+ added light mode theme 
! improved tooltip handling so that they don't pause the program

NOTE! This is the Last Release!

Unless anyone reports bug issues. There's likely a few small ones.
Thou...
I've been using this and am content with it.
I'll be uploading the source code and required icons to github soon.
Y'all can have some fun tweaking it if you wish.


;------------------------- v.2025.03.23

** changed app icon to the new win11 fluent style
!* adjusted searching icons with everything to only send the icon name rather then the full path, and removed the "quotes" it was sending around search terms
+ added a hotkey to send icon searches to everything
! fixed reload hotkey conflict that was causing it not to show up in live menu and buttons


;------------------------- v.2025.03.20

* gui layout tweaks
+ added dynamic hotkeys labels to buttons
! fixed window position incorrectly being written to .ini
!+ fixed and added saving window position on a Reload, it only saved on Exit before

* Cleaned up dynamic menus a bit...
+ increased the folder & icon history to 30 items from 15
+ added modifier + click functionality History menu with labels where they apply.
+ added the ability to delete individual items from the history if the menu starts to get to large without erasing the entire history. Hold ctrl+shift and click to delete a single item.
+ added Friendly\Readable Menu names to the items on the Quick Actions & Live Hotkeys Menu


;------------------------- v.2025.03.15

+ added Everything1.5a, https://www.voidtools.com/forum/viewtopic.php?t=9787, integration to the apps bar. it will send any search text or an .ico path to Everything with extension file filter in place for searching .ico's on your C: drive, e.g. ext:ico c: folder icon

+ started and included this changelog

! improvements to saving folder & icon history when update the ini file


;------------------------- v2025.03.11

added the ability to click and drag on the gui to move it

! important ! FIX - Removed an accidentally left behind hotkey, NumbadSub that was being used for testing

Fixed\Improved file versioning checks for proper updates when a new version\installer is run from within or at the parent level dir

To update, run this inside the folder an existing install.

updated github in app menu

fixed minor menu error

fixed typo in start menu link

;------------------------- v2025.03.10

1st Release

Download Portable Installer, it will copy itself into its own directory with some icons and a settings.ini

No system changes are made.

;------------------------- v.2025.03.27

* GUI Updates...
*+ added icons to all GUI buttons, because... ICONS!
* changed all buttons darkmode.
+ added light mode theme
! improved tooltip handling so that they don't pause the program

NOTE! This is the Last Release!

Unless anyone reports bug issues. There's likely a few small ones.
Thou...
I've been using this and am content with it.
I'll be uploading the source code and assistes to github soon.
Y'all can have some fun tweaking it if you wish.


;------------------------- v.2025.03.23

** changed app icon to the new win11 fluent style
!* adjusted searching icons with everything to only send the icon name rather then the full path, and removed the "quotes" it was sending around search terms
+ added a hotkey to send icon searches to everything
! fixed reload hotkey conflict that was causing it not to show up in live menu and buttons


;------------------------- v.2025.03.20

* gui layout tweaks
+ added dynamic hotkeys labels to buttons
! fixed window position incorrectly being written to .ini
!+ fixed and added saving window position on a Reload, it only saved on Exit before

* Cleaned up dynamic menus a bit...
+ increased the folder & icon history to 30 items from 15
+ added modifier + click functionality History menu with labels where they apply.
+ added the ability to delete individual items from the history if the menu starts to get to large without erasing the entire history. Hold ctrl+shift and click to delete a single item.
+ added Friendly\Readable Menu names to the items on the Quick Actions & Live Hotkeys Menu


;------------------------- v.2025.03.15

+ added Everything1.5a, https://www.voidtools.com/forum/viewtopic.php?t=9787, integration to the apps bar. it will send any search text or an .ico path to Everything with extension file filter in place for searching .ico's on your C: drive, e.g. ext:ico c: folder icon

+ started and included this changelog

! improvements to saving folder & icon history when update the ini file


;------------------------- v2025.03.11

added the ability to click and drag on the gui to move it

! important ! FIX - Removed an accidentally left behind hotkey, NumbadSub that was being used for testing

Fixed\Improved file versioning checks for proper updates when a new version\installer is run from within or at the parent level dir

To update, run this inside the folder an existing install.

updated github in app menu

fixed minor menu error

fixed typo in start menu link

;------------------------- v2025.03.10

1st Release

Download Portable Installer, it will copy itself into its own directory with some icons and a settings.ini

No system changes are made.


)
FileAppend, %changelogbody%, %changelog%, UTF-8
sleep 1000
return

; INIReadSection(sectionName) ;; function ;; check x[env] dupe. oktd?
; {
    ; global
    ; IniRead, SectionContent, %inifile%, %sectionName%
    ; if (SectionContent = "ERROR")
        ; return

    ; Loop, Parse, SectionContent, `n, `r
    ; {
        ; if (A_LoopField = "")
            ; continue

        ; KeyParts := StrSplit(A_LoopField, "=")
        ; if (KeyParts.Length() < 2)
            ; continue

        ; VarName := KeyParts[1]
        ; VarValue := KeyParts[2]

        ; if (VarValue = "" || VarValue = "ERROR")
            ; VarValue := (sectionName = "Settings") ? 0 : ""  ; Default Settings to 0 if empty

        ; %VarName% := VarValue
    ; }
; }



INIReadHotkeySection(sectionName) ;; function ;; v8 - FIXED: Menu shows ReadableHotkey, keeps raw hotkeys global
{
    global
    IniRead, HotkeySection, %inifile%, %sectionName%
    if (HotkeySection = "ERROR")
        return

    local inikeycount := 0
    local MenuItems := ""  ; String to store sortable items

    Loop, Parse, HotkeySection, `n, `r
    {
        if (A_LoopField = "")
            continue

        KeyParts := StrSplit(A_LoopField, "=")
        if (KeyParts.Length() < 2)
            continue

        LabelName := Trim(KeyParts[1])
        FullValue := Trim(KeyParts[2])

        if (FullValue = "" || FullValue = "ERROR")
            continue

        ValueParts := StrSplit(FullValue, "|")
        HotkeyValue := Trim(ValueParts[1])
        FriendlyName := (ValueParts.Length() > 1 && ValueParts[2] != "") ? Trim(ValueParts[2]) : LabelName

        ; Store raw hotkey globally under its label
        %LabelName% := HotkeyValue  

        try {
            Hotkey, %HotkeyValue%, %LabelName%, On
            inikeycount++
            totaliniCount++
        } catch {
            continue
        }

        ReadableHotkey := ConvertAHKSymbolToWords(HotkeyValue)
        MenuItems .= FriendlyName "¦" ReadableHotkey "¦" LabelName "`n"  ; Store sortable format
    }

    ; **Sort menu items alphabetically by FriendlyName**
    Sort, MenuItems

    ; **Rebuild menu with sorted items**
    Loop, Parse, MenuItems, `n
    {
        if (A_LoopField = "")
            continue

        Parts := StrSplit(A_LoopField, "¦")
        FriendlyName := Parts[1]
        ReadableHotkey := Parts[2]  ; Now storing human-readable hotkey
        LabelName := Parts[3]

        DisplayName := FriendlyName . "`t" . ReadableHotkey  ; Now menu shows readable hotkeys

        MenuVars[DisplayName] := LabelName  ; Store label name under the menu item
        Menu, k, Add, %DisplayName%, %LabelName%
    }
}

ConvertAHKSymbolToWords(hotkey)
{
    hotkey := StrReplace(hotkey, "+", "Shift+")
    hotkey := StrReplace(hotkey, "^", "Ctrl+")
    hotkey := StrReplace(hotkey, "!", "Alt+")
    hotkey := StrReplace(hotkey, "#", "⊞+") ; ⊞ + 
    ; hotkey := StrReplace(hotkey, "⊞", "Win+")
    return hotkey
}

showhotkeymenu:
CoordMode,menu,client
menu, k, show,10,10
return

INIReadHotkeys() ;; function
{
    global
    IniRead, HotkeySection, %inifile%, Hotkeys
    if (HotkeySection = "ERROR")
        return

    Loop, Parse, HotkeySection, `n, `r
    {
        if (A_LoopField = "")
            continue

        KeyParts := StrSplit(A_LoopField, "=")
        if (KeyParts.Length() < 2)
            continue

        LabelName := KeyParts[1]
        HotkeyValue := KeyParts[2]

        if (HotkeyValue = "" || HotkeyValue = "ERROR")
            continue

        try {
			; Hotkey, IfWinActive, - Change Folder .Ico - ahk_class AutoHotkeyGUI
            Hotkey, %HotkeyValue%, %LabelName%, On
			; hotkey, IfWinActive
        } catch {
            continue
        }
    }
}
UpdateINI(inifile, section, key, defaultValue) { ;; when and why I put this here? its it being usesed?
	;; e.g. UpdateINI(inifile, "General", "Theme", "Dark")
    IniRead, userValue, %inifile%, %section%, %key%, ERRORVALUE  ; Reliable default

    if (userValue = "ERRORVALUE") {  ; If key is missing, write default
        IniWrite, %defaultValue%, %inifile%, %section%, %key%
    }
}


	
VisitGithub:
VisitGithubWebpage:
run %githuburl%
return



;; work, keep testing others
BuildIconHistoryMenu: ;; add icon? X:\AHK\Icons\documents multimedia imageres_5334_256x256.ico
MENU, h, add
Menu, h, DeleteAll ; Clear previous menu
menu, h, add, Icon History  --> (Click to Save Active Icon For Later)`t%SaveIconToHistory%, SaveIconToHistory
menu, h, Icon, Icon History  --> (Click to Save Active Icon For Later)`t%SaveIconToHistory%, %icons%\ChangeFolderIcon.ico,,32
menu, h, add, ; line -------------------------
Loop, %History_NumberOfItemsToRemember%
{
    IniRead, Icon, %IniFile%, Icon_History, Entry%A_Index%, %A_Space%
    ; log .= "Entry " A_Index ": " folder "`n"  ; Log what was read ;; debug
    if (icon != "" && icon != A_Space) {
        Menu, h, Add, %icon%, loadhistoryicon
        Menu, h, icon, %icon%, % GetFileIcon(icon),,%is%
        historyFound := true
    }
}
if (historyfound)
	{
		menu, h, add, ; line -------------------------
		menu, h, add, Hold Ctrl+Shift && Click to Delete Single Items from History. Delete All in Settings Menu., ShowSettingsMenu
		menu, h, icon, Hold Ctrl+Shift && Click to Delete Single Items from History. Delete All in Settings Menu., %icons%\about.ico
	}
return
BuildFolderHistoryMenu:
FolderHistoryMenu:

MENU, h, add
Menu, h, DeleteAll ; Clear previous menu

Menu, h, Add, Folder History  --> (Click to Save Active Folder For Later)`t%SaveFolderToHistory%, SaveFolderToHistory
Menu, h, icon, Folder History  --> (Click to Save Active Folder For Later)`t%SaveFolderToHistory%, %icons%\folderhistory.ico,,32
Menu, h, default, Folder History  --> (Click to Save Active Folder For Later)`t%SaveFolderToHistory%
; Menu, h, Disable, Folder History
Menu, h, Add ; Separator

historyFound := false
; log := "Reading History Entries:`n`n" ;; debug
Loop, %History_NumberOfItemsToRemember%
{
    IniRead, folder, %IniFile%, Folder_History, Entry%A_Index%, %A_Space%
    ; log .= "Entry " A_Index ": " folder "`n"  ; Log what was read ;; debug
    if (folder != "" && folder != A_Space) {
        Menu, h, Add, %folder%, LoadHistoryFolder
        Menu, h, icon, %folder%, % GetFileIcon(folder),,%is%
        historyFound := true
		
    }
}
if (historyfound)
	{
		Menu, h, add, ; line -------------------------
		menu, h, add, 🡱 Hold Ctrl && Click to Open Folder in File Manager 🡱 , donothing
		menu, h, icon, 🡱 Hold Ctrl && Click to Open Folder in File Manager 🡱 , %icons%\about.ico
	}
if (!historyFound) ; If no history exists, add a placeholder entry
    {
        Menu, h, Add, (No History Found!), donothing
        Menu, h, icon, (No History Found!), %iconerror%,,32
        Menu, h, default, (No History Found!)
        ; menu, h, delete, Delete History
	}
; menu, h, add, ; line -------------------------
; menu, h, add, Icon History  --> (Click to Save Active Icon For Later)`t%SaveIconToHistory%, SaveIconToHistory
; menu, h, Icon, Icon History  --> (Click to Save Active Icon For Later)`t%SaveIconToHistory%, %icons%\ChangeFolderIcon.ico,,%is%
; menu, h, add, ; line -------------------------
; Loop, 30
; {
    ; IniRead, Icon, %IniFile%, Icon_History, Entry%A_Index%, %A_Space%
    ;;;; log .= "Entry " A_Index ": " folder "`n"  ; Log what was read ;; debug
    ; if (icon != "" && icon != A_Space) {
        ; Menu, h, Add, %icon%, loadhistoryicon
        ; Menu, h, icon, %icon%, % GetFileIcon(icon)
        ; historyFound := true
    ; }
; }
; if (historyfound)
	; {
		; menu, h, add, ; line -------------------------
		; menu, h, add, Hold Ctrl+Shift && Click to Delete Single Items from History. Delete All in Settings Menu., ShowSettingsMenu
		; menu, h, icon, Hold Ctrl+Shift && Click to Delete Single Items from History. Delete All in Settings Menu., %icons%\about.ico,,%is%
	; }
Return
ShowIconHistoryMenu:
gosub BuildIconHistoryMenu
Menu, h, show, 10, 10
return
ShowFolderHistoryMenu:
coordmode,Menu,Client
gosub BuildFolderHistoryMenu
menu, h, show,10,10
return

LoadHistoryFolder:
if (GetKeyState("Control", "P") && GetKeyState("Shift", "P"))
{
	clickedEntry := A_ThisMenuItem  ; The text of the clicked menu item
	Loop, %History_NumberOfItemsToRemember% ; Loop through your INI entries to find the matching one
	{
		IniRead, thisEntry, %inifile%, Folder_History, Entry%A_Index%
		if (thisEntry = clickedEntry)
		{
			IniDelete, %inifile%, Folder_History, Entry%A_Index%
			break
		}
	}
	Return  ; Stop further processing
}
if (GetKeyState("Control", "P"))
{
	clickedEntry := A_ThisMenuItem
	run %A_ThisMenuItem%
	return
}
folder := A_ThisMenuItem
GuiControl,, folderpath, %folder%
gosub LoadFolderPath
; sleep 200
gosub PreviewIcon
Return

loadhistoryicon:
if (GetKeyState("Control", "P") && GetKeyState("Shift", "P"))
{
	clickedEntry := A_ThisMenuItem  ; The text of the clicked menu item
	Loop, %History_NumberOfItemsToRemember% ; Loop through your INI entries to find the matching one
	{
		IniRead, thisEntry, %inifile%, Icon_History, Entry%A_Index%
		if (thisEntry = clickedEntry)
		{
			IniDelete, %inifile%, Icon_History, Entry%A_Index%
			break
		}
	}
	Return  ; Stop further processing
}
icon := A_ThisMenuItem
GuiControl,,iconpath, %icon%
gosub PreviewIcon
return
deletefolderhistorysection:
MsgBox, 4148, - Change Folder .Ico - ? Delete History, Deleting Folder & Icon History...`n`nThis cannot be undone.`n`nContinue... ??
IfMsgBox No
	return
inidelete, %inifile%, Folder_History
inidelete, %inifile%, Icon_History
return


SaveFolderToHistory:
gui,submit,nohide
if Fileexist(folderpath)
	{
		SaveFolderHistory(folderpath)
		tooltip Folder saved to history.
	}
else
	{
		tooltip The Folder path does not exisit.`nNothing to save.
	}
SetTimer, RemoveTooltip, -2000	
return
SaveIconToHistory:
gui,submit,nohide
if Fileexist(iconpath)
{
    SaveIconHistory(iconpath)
    ; SplitPath,iconpath,,,ext ;; no longer limiting to .ico file, oktd
    ; if (ext = "ico")
    ; {
        ; SaveIconHistory(iconpath)
        ; tooltip Icon saved to history.
        ; SetTimer, RemoveTooltip, -2000	
        ; return
    ; }
    ; else
    ; {
        ; tooltip, Only .ico files can be saved.
        ; SetTimer, RemoveTooltip, -2000	
        ; return
    ; }
}
else
{
    tooltip The Icon path does not exisit.`nNothing to save.
    SetTimer, RemoveTooltip, -2000	
}
return

SaveFolderHistory(folder) {
    global IniFile

    history := []    ; Read existing history from the [History] section
    seen := {}  ; Dictionary to track unique entries

    Loop, %History_NumberOfItemsToRemember%
    {
        IniRead, entry, %IniFile%, Folder_History, Entry%A_Index%, %A_Space%  ; Default to space if not found
        entry := Trim(entry)  ; Remove accidental spaces

        if (entry != "" && entry != A_Space && !seen.HasKey(entry)) {        ;  Only add if not blank and not already in dictionary (case insensitive)
            history.Push(entry)
            seen[entry] := true  ; Mark as seen
        }
    }

    folder := Trim(folder)  ; Ensure no accidental spaces    ; Prevent adding a duplicate of `folder`
    if (folder != "" && !seen.HasKey(folder)) {
        history.InsertAt(1, folder)  ; Add new entry at the top
        seen[folder] := true  ; Mark it as seen
    }

    while (history.Length() > History_NumberOfItemsToRemember)    ; Keep only the last 30 entries
        history.Pop()

    IniDelete, %IniFile%, Folder_History    ; Clear the INI section before writing to prevent gaps

    Loop % history.Length()    ;  Write the cleaned-up list back
        IniWrite, % history[A_Index], %IniFile%, Folder_History, Entry%A_Index%
}

SaveIconHistory(icon) {
    global IniFile

    history := []    ; Read existing history from the [History] section
    seen := {}  ; Dictionary to track unique entries

    Loop, %History_NumberOfItemsToRemember%
    {
        IniRead, entry, %IniFile%, Icon_History, Entry%A_Index%, %A_Space%  ; Default to space if not found
        entry := Trim(entry)  ; Remove accidental spaces

        if (entry != "" && entry != A_Space && !seen.HasKey(entry)) {        ;  Only add if not blank and not already in dictionary (case insensitive)
            history.Push(entry)
            seen[entry] := true  ; Mark as seen
        }
    }

    icon := Trim(icon)  ; Ensure no accidental spaces    ; Prevent adding a duplicate of `folder`
    if (icon != "" && !seen.HasKey(icon)) {
        history.InsertAt(1, icon)  ; Add new entry at the top
        seen[icon] := true  ; Mark it as seen
    }

    while (history.Length() > History_NumberOfItemsToRemember)    ; Keep only the last 30 entries
        history.Pop()

    IniDelete, %IniFile%, Icon_History    ;  Clear the INI section before writing to prevent gaps

    Loop % history.Length()    ;  Write the cleaned-up list back
        IniWrite, % history[A_Index], %IniFile%, Icon_History, Entry%A_Index%
}

checkclipboardformenu:
;; onload check the clipboard for an existing filepath, if found load it automatically into the folderpath.
return

GuiContextMenu:
gosub guimenu
Return
GuiContextMenu() ;; fucnction - right click menu
{
	gosub guimenu
	; menu, x, show
	; return
}

showguimenu:
guimenu:
showEditInf := 0
gui, submit, nohide
; GuiControlGet, currentIconPath,, iconpath
; guicontrolget, currentFolderpath,, folderpath
; guicontrolget, currrentdesktopini,, IniPreview
Menu, rc, add,
Menu, rc, deleteall
; Menu, rc, add, - Change Folder .Ico -, showguimenu ;; gui menu
; Menu, rc, icon, - Change Folder .Ico -, %trayicon%,,28
; Menu, rc, default, - Change Folder .Ico -
; Menu, rc, add, ; line -------------------------
if FileExist(clipboard)
{
			Menu, rc, add, Clipboard Check ...., guimenu
			Menu, rc, icon, Clipboard Check ...., %icons%\checkclipboard.ico,,%is%
			Menu, rc, disable, Clipboard Check ....
	SplitPath,clipboard,,,ext
	if (ext = "ico")
		{
			; Menu, rc, add, Clipboard Check ...., guimenu
			; Menu, rc, icon, Clipboard Check ...., %icons%\clipboardicon.ico,,%is%
            ; Menu, rc, disable, Clipboard Check ....
			Menu, rc, add, Paste Icon Path into GUI`t%CheckClipboard4ICO%, CheckClipboard4ICO
			Menu, rc, icon, Paste Icon Path into GUI`t%CheckClipboard4ICO%, % Getfileicon(clipboard),,%is%
			
			
					; Menu, d, add, Selected: %dopesel%, applySel 
		; Menu, d, Icon, Selected: %dopesel%, % GetFileIcon(dopesel) ;; get file icon
		}
	else
	{
		FileGetAttrib, clipboardcheck, %clipboard%
		if InStr(clipboardcheck, "D")
			{
				Menu, rc, add, Paste Folder Path Into GUI`t%CheckClipboard4FOLDER%, CheckClipboard4FOLDER
				Menu, rc, icon, Paste Folder Path Into GUI`t%CheckClipboard4FOLDER%, % Getfileicon(clipboard),,%is%
			; Menu, rc, icon, Paste Folder Path Into GUI, % Getfileicon(clipboard)
			}
		else
			{
				SplitPath,clipboard,filename,folderpath
				Menu, rc, add, Paste Folder Path Into GUI`t%CheckClipboard4FOLDER%, CheckClipboard4FOLDER

			}
	}
	Menu, rc, add, ; line -------------------------
	skiptip := 1
}
; if Fileexist(currentIconPath) || FileExist(currentFolderpath)
	; {
        ; Menu, rc, add, Working Fields Options ...., guimenu
        ; Menu, rc, icon, Working Fields Options ...., %icons%\openfolders.ico,,%is%
        ; Menu, rc, add, ; line -------------------------
	; }
	


; if FileExist(currentFolderpath)
if FileExist(Folderpath)
	{
        Menu, rc, add, Active Folder Options ...., guimenu
        Menu, rc, icon, Active Folder Options ...., %icons%\openfolders.ico,,%is%
        Menu, rc, disable, Active Folder Options ....
        
		Menu, rc, add, Copy Current Folder Path, copyworkingfolder
		Menu, rc, icon, Copy Current Folder Path, %icons%\copy.ico,,%is% ; %icons%\checkclipboard.ico
		Menu, rc, add, Open Current Folder Path, openworkingfolder
		if Fileexist(dopus)
			Menu, rc, icon, Open Current Folder Path, %dopus%,,%is%
		else
			Menu, rc, icon, Open Current Folder Path, Explorer.exe,,%is%
		; Menu, rc, icon, Copy Current Icon Path, % Getfileicon(currentIconPath)
		if Fileexist(desktopini)
			{
				Menu, rc, add, Edit Current Folder's desktop.ini, openini
				Menu, rc, icon, Edit Current Folder's desktop.ini, %icons%\iniicon.ico,,%is%
				; Menu, rc, add, ; line -------------------------
			}
        global ActiveARinf := Folderpath "\autorun.inf"
        If FileExist(ActiveARinf)
            showEditInf := 1
		Menu, rc, add, ; line -------------------------
	}
;--------------------------------------------------
; if Fileexist(currentIconPath)
if Fileexist(IconPath)
	{
    ; if FileExist(iconpath) ; viconpath
	; {
	; SplitPath, iconpath, iconame, icodir
	; menu, f, add, Icon Folder: %icodir%, openiconfolder ; openiconpathfolder
        Menu, rc, add, Active Icon Options ...., guimenu
        Menu, rc, icon, Active Icon Options ...., %icons%\ChangeFolderIcon.ico,,%is%
        Menu, rc, disable, Active Icon Options ....
        
		SplitPath, iconpath,,cipdir
		Menu, rc, add, Copy Current Icon Path, CopyIconPath
		Menu, rc, icon, Copy Current Icon Path, % Getfileicon(IconPath),,%is%
		Menu, rc, add, Open Current Icon Path Folder, openiconfolder
				if Fileexist(dopus)
			Menu, rc, icon, Open Current Icon Path Folder, %dopus%,,%is%
		else
			Menu, rc, icon, Open Current Icon Path Folder, Explorer.exe,,%is%
		Menu, rc, add, ; line -------------------------
	}
    
    

    
    
if (folderpath = "" && iconpath = "")
	{
		Menu, rc, add, Both path fields are empty., donothing
		Menu, rc, icon, Both path fields are empty., %iconerror%,,%is%
		; Menu, rc, Default, Both path fields are empty.
		Menu, rc, add, ; line -------------------------
	}
; ini check? edit desktop.ini?
if Fileexist(IconPath) && FileExist(Folderpath)
	{
		Menu, rc, add, ; line -------------------------
        Menu, rc, add, Set Icon, guimenu
        Menu, rc, icon, Set Icon, %icons%\savegreen.ico,,%is% 
If (showEditInf)
{
    Menu, rc, add, Edit %ActiveARinf%, EditLiveARinf
    Menu, rc, Icon, Edit %ActiveARinf%, %te%,,%is%
}
If FileExist(desktopini)
{
    Menu, rc, add, Edit Desktop.ini directly, openini
    Menu, rc, Icon, Edit Desktop.ini directly, Notepad.exe,,%is%
}
        Menu, rc, add, ; line -------------------------
	}
if (pin)
	{
		Menu, rc, add, Unpin from Top`t%AlwaysOnTopToggle%, pinunpin
		Menu, rc, icon, unpin from top`t%AlwaysOnTopToggle%, %pinNN%,,%is%
	}
else
	{
		Menu, rc, add, Pin to Top`t%AlwaysOnTopToggle%, pinunpin
		Menu, rc, icon, Pin to Top`t%AlwaysOnTopToggle%, %pinFF%,,%is%
	}
Menu, rc, add, Reload CFIco`t%ReloadCFI%, ReloadCFI
Menu, rc, icon, Reload CFIco`t%ReloadCFI%, %icons%\reload.ico,,%is%
Menu, rc, add, ; line -------------------------
Menu, rc, add, Quick Actions && Hotkeys Menu >>>`t%Showhotkeymenu%, :k
Menu, rc, icon, Quick Actions && Hotkeys Menu >>>`t%Showhotkeymenu%, %icons%\hotkeys.ico,,%is%
Menu, rc, add, Settings Menu >>>`t%ShowSettingsMenu%, :s
Menu, rc, Icon, Settings Menu >>>`t%ShowSettingsMenu%, %icons%\iniicon.ico,,%is%
Menu, rc, add, Tray menu >>>, :tray
Menu, rc, Icon, Tray menu >>>, %icons%\systray.ico,,%is% 
Menu, rc, add, ; line -------------------------
Menu, rc, add, Quit \ Exit`t%exit%, exit
Menu, rc, icon, Quit \ Exit`t%exit%, %icons%\exitapp.ico,,%is%
Menu, rc, show
return



setmenu:
menu, s, add
menu, s, deleteall
menu, s, add, Change Folder .Ico -- Settings Menu`t%showsettingsmenu%, showsettingsmenu
menu, s, icon, Change Folder .Ico -- Settings Menu`t%showsettingsmenu%, %icons%\changefoldericon.ico,,32
menu, s, default, Change Folder .Ico -- Settings Menu`t%showsettingsmenu%,
menu, s, add, ; line -------------------------
if WinExist("ahk_class dopus.lister") && !FileExist(dopusrt)
{
    menu, s, add, Update Dopus Location!!!, updatedopusrt
    menu, s, icon, Update Dopus Location!!!, %icons%\attention.ico,,28
    menu, s, default, Update Dopus Location!!!
    menu, s, add, ; line -------------------------
}
Menu, s, Add, Toggle  Dark <> Light  Theme`t%DMToggle%, DMToggle 
Menu, s, icon, Toggle  Dark <> Light  Theme`t%DMToggle%, %icons%\darkmode.ico,,%is%

menu, s, add, Remember Window Position, togrememeberwindowpostion
menu, s, icon, Remember Window Position, %icons%\winpos.ico,,%is%
if (RememberWindowPos)
	menu, s, ToggleCheck, Remember Window Position
menu, s, add, Start Pinned to Top, Pintoggle
menu, s, icon, Start Pinned to Top, %icons%\pinnedtotop.ico,,%is%
if (startontop)
	menu, s, ToggleCheck, Start Pinned to Top
	
menu, s, add, Remember Changed Folder History, historytoggle
menu, s, icon, Remember Changed Folder History, %icons%\folderhistory.ico,,%is%
if (RememberHistory)
	menu, s, ToggleCheck, Remember Changed Folder History

Menu, s, add, Auto Load Last Folder on Start Up, toggleOnStartUp_AutoLoadLastFolder
Menu, s, Icon, Auto Load Last Folder on Start Up, %icons%\arrowquick.ico,,%is%
if (OnStartUp_AutoLoadLastFolder)
    Menu, s, ToggleCheck, Auto Load Last Folder on Start Up


Menu, s, add, Ask Me To Confirm On Save, ToggleAskMeToConfirmOnSave
Menu, s, Icon, Ask Me To Confirm On Save, %icons%\buttonok.ico,,%is%
if (AskMeToConfirmOnSave)
    Menu, s, togglecheck, Ask Me To Confirm On Save
    
menu, s, add, Auto check for folder path in clipboard on startup, togautoclipboard
menu, s, icon, auto check for folder path in clipboard on startup, %icons%\checkclipboard.ico,,%is%
if (AutoCheckClipboard4Path)
	menu, s, togglecheck, Auto check for folder path in clipboard on startup



menu, s, add, Hide Tooltips. I know my way around now.`t%togToolTips%, togtooltips
menu, s, icon, Hide Tooltips. I know my way around now.`t%togToolTips%, %icons%\tooltip.ico,,%is%
if (HideTooltips)
	menu, s, ToggleCheck, Hide Tooltips. I know my way around now.`t%togToolTips%
menu, s, add, Hide the App Bar, Toggleappbar
menu, s, icon, Hide the App Bar, %mspaint%,,%is%
if !(ShowAppBar)
	menu, s, togglecheck, Hide the App Bar
; menu, s, add, Hide Optional Folder Info Tip Extras, Toginfotips
; menu, s, icon, Hide Optional Folder Info Tip Extras, %icons%\tooltip.ico,,%is%
; if !(showInfoTipExtras)
	; menu, s, togglecheck, Hide Optional Folder Info Tip Extras

menu, s, add, ; line -------------------------
menu, s, add, Edit Settings File`t%editCFIsettings%, editini
menu, s, icon, Edit Settings File`t%editCFIsettings%, %icons%\settingsaltini.ico,,%is%
if FileExist(startlink)
{
Menu, s, add, Remove Shortcut from Start Menu, MakeStartLink
Menu, s, Icon, Remove Shortcut from Start Menu, %icons%\startmenu.ico,,%is%
}
else
{
menu, s, add, Create Shortcut in Start Menu, MakeStartLink
menu, s, icon, Create Shortcut in Start Menu, %icons%\startmenu.ico,,%is%
}

	; menu, s, disable, Create Shortcut in Start Menu
Menu, s, add, ; line -------------------------

if !(a_isadmin)
	{
	menu, s, add, Run as Admin`t%RunAsAdmin%, RunAsAdmin
	menu, s, icon, Run as Admin`t%RunAsAdmin%, %Icons%\admin.ico,,%is%
	}
else
	{
	Menu, s, add, Script is Running as ADMIN, warnadmin
	menu, s, icon, Script is Running as ADMIN, %Icons%\adminrunning.ico,,%is%
	}
	
menu, s, add, ** Always Force Windows to Apply New Icons on Save, ForceApplyNOWtoggle ;ForceApplyNOWtoggle
menu, s, icon, ** Always Force Windows to Apply New Icons on Save, %icons%\forcewinreload.ico,,%is%
if (ForceApplyNOW)
	menu, s, ToggleCheck,  ** Always Force Windows to Apply New Icons on Save
menu, s, add, Force Windows Explorer && Icon Cache Reload **NOW`t%ForceWindowExplorerReload%, ForceWindowExplorerReload ;forcewinreload
menu, s, icon, Force Windows Explorer && Icon Cache Reload **NOW`t%ForceWindowExplorerReload%, %Icons%\adminrunning.ico,,%is%
; If (A_Username != "CLOUDEN")
	; {
		menu, s, add, Delete Folder && Icon History's, deletefolderhistorysection
		menu, s, icon, Delete Folder && Icon History's, %icons%\trashbin.ico,,%is%
	; }
If FileExist(dopus)
{
Menu, s, add, Copy Dopus Button CMD, CopyDopusButtonCode
Menu, s, Icon, Copy Dopus Button CMD, %dopus%,4,%is%

}
menu, s, add, ; line -------------------------
Menu, s, add, About`t%AboutMessage%, AboutMessage
Menu, s, icon, About`t%AboutMessage%, %icons%\about.ico,,%is%
menu, s, add, Visit Github Webpage`t%visitgithubwebpage%, VisitGithub
menu, s, icon, Visit Github Webpage`t%visitgithubwebpage%, %icons%\Githubicon.ico,,%is%
; menu, s, add, Full Hotkey Menu >>>`t%showhotkeymenu%, :k
menu, s, add, Quick Actions && Hotkeys Menu >>>`t%showhotkeymenu%, :k
menu, s, icon, Quick Actions && Hotkeys Menu >>>`t%showhotkeymenu%, %icons%\hotkeys.ico,,%is%
menu, s, add, ; line -------------------------
Menu, s, add, Tray Menu, :tray
Menu, s, Icon, Tray Menu, %icons%\systray.ico,,%is%
menu, s, add, Reload`t%reloadCFI%, reloadCFI
menu, s, icon, Reload`t%reloadCFI%, %icons%\reload.ico,,%is%
menu, s, add, Quit \ Exit`t%exit%, exit
menu, s, icon, Quit \ Exit`t%exit%, %icons%\exitapp.ico,,%is%

if (A_Username = "CLOUDEN") || if (DevMode)
{
    menu, s, add, ; line ------------------------- 
    menu, s, add, Edit Script`t%editscript%, editscript
    menu, s, icon, Edit Script`t%editscript%, %texteditor%,,%is%
	; menu, s, add, Open A_ScriptDir`t%openscriptdir%, openscriptdir
	; menu, s, icon, Open A_ScriptDir`t%openscriptdir%, explorer.exe
}

return

CompileThisScriptInternal:
CompileCFICO:
If FileExist(compilex)
{
    run, %compilex% "%SourceScript%"
    sleep 750
    exitapp

}
; SendToScript("func|CompileX|" SourceScript "", Main)
; sleep 500
; exitapp
; source := A_ScriptDir "\ChangeFolderIcon.ahk"
; SendToScript("Func|CompileX|" source "", "xxx.ahk")
return

EditLiveARinf:
    ; Menu, dl, add, Edit %livearinf%, 
getlivefile := A_thismenuitem
livefile := trim(StrReplace(getlivefile, "Edit "))
; box(livefile)
If FileExist(livefile)
{
    try run, %livefile%
    catch
        try run, %te% %livefile%
}
return

Showsettingsmenu:
gosub setmenu
CoordMode,menu,client
menu, s, show,10,10
return
openscriptdir:
run "%a_scriptdir%"
return

Editscript:
if !(A_IsCompiled)
	run %TE% "%a_scriptfullpath%"
else if FileExist(A_scriptdir "\" A_ScriptStem ".ahk")
    run, %TE% "%A_ScriptDir%\%A_ScriptStem%.ahk"
else
	Run "%A_scriptdir%"
return

openfolderpropteries:
gui, submit,hide
if fileexist(folderpath)
    if FileExist(dopusrt)
        run, %dopusrt% /cmd Properties "%iconpath%"
    else
        run, Properties "%folderpath%"
    else
    {
        Tooltip, ERR! @ Line#:  %A_LineNumber%`nThe file from your selection could not be found.
        SetTimer, RemoveTooltip, -2000	
    }
return

togrememeberwindowpostion:
RememberWindowPos := !RememberWindowPos
if (RememberWindowPos) ; RememberWindowPos
{
    iniwrite, 1, %inifile%, Settings, RememberWindowPos
    menu, s, ToggleCheck, Remember Window Position
}
else
{
    iniwrite, 0, %inifile%, Settings, RememberWindowPos
    menu, s, ToggleCheck, Remember Window Position
}
tooltip This setting requires a reload to take affect
SetTimer, RemoveTooltip, -3000	
return

togtooltips:
HideTooltips := !HideTooltips
if (HideTooltips)
	{
		iniwrite, 1, %inifile%, Settings, HideTooltips
		AddTooltip("Deactivate")	
		menu, s, ToggleCheck, Hide Tooltips. I know my way around now.`t%togToolTips%
	}
else
	{
		iniwrite, 0, %inifile%, Settings, HideTooltips
		AddTooltip("Activate")
		menu, s, ToggleCheck, Hide Tooltips. I know my way around now.`t%togToolTips%
	}
return

Hotkeyhelp:
Hotkeytip= 
(

There are more hotkeys than there are menuitems in the setting file that you can customaize from the settings menu.

The Hotkeys menu will update if you change them and only appear when set. You're free to removed them as well.

[Hotkeys]
This Section only works when the...
- Change Folder .Ico -
... window is active. Most but not all have menu items

[Global_Hotkeys]
These apply system wide!
You can move the labels from above down here
if you want to and they will change according. 
Thou most of them aren't practily as global keys.


TO SET HOTKEYS

Set the Key after, to the right of the " = " and before the " | "
** Do not rename the labels to left of the " = "
if you feel like you broke something, just rename or delete the settings file. The program will make a new default one upon reloading.

AutoHotkey's Modifier Symbols are...
Ctrl = ^
Shift = +
Win = #
Alt = !

Would you like to open the settins file now?

OK = Open -SETTINGS.ini
Cancel = Maybe Next Time
)

MsgBox, 262468, - Change Folder .Ico - ? Hotkey Help ?,%Hotkeytip%
IfMsgBox, Yes
	goto EditCFISettings
return

EditCFISettings:
editini:
if (GetKeyState("Control", "P"))
{
    Run, %inifile%
    return
}
If FileExist(iie)
{
    iieini := "X:\AHK\x.ini"
    if WinExist("- iniEditor ahk_class AutoHotkeyGUI")
    {
        iniwrite, Settings, %iieini%, inieditor_config, ASDToLoad
        iniwrite, %soloini%, %iieini%, inieditor_config, ASDFileToLoad
        SendToScript("SideLoadASDSection", "iniEditor.exe")
        WinActivate, - iniEditor ahk_class AutoHotkeyGUI
    }
        ; LoadASDSection("Settings", soloini)
    else
        run, %iie% /s Settings "%inifile%"
    return
}
try run %inifile%
catch
try run notepad++.exe "%inifile%"
catch
try run notepad.exe "%inifile%"
return
toggleOnStartUp_AutoLoadLastFolder:
OnStartUp_AutoLoadLastFolder := !OnStartUp_AutoLoadLastFolder
if (OnStartUp_AutoLoadLastFolder)
    iniwrite, 1, %inifile%, Settings, OnStartUp_AutoLoadLastFolder
else
    iniwrite, 0, %inifile%, Settings, OnStartUp_AutoLoadLastFolder
Menu, s, ToggleCheck, Auto Load Last Folder on Start Up
return

ToggleAskMeToConfirmOnSave:
AskMeToConfirmOnSave := !AskMeToConfirmOnSave
if (AskMeToConfirmOnSave)
    iniwrite, 1, %inifile%, Settings, AskMeToConfirmOnSave
else
    iniwrite, 0, %inifile%, Settings, AskMeToConfirmOnSave
Menu, s, ToggleCheck, Ask Me To Confirm On Save
return

historytoggle:
RememberHistory := !RememberHistory
if (RememberHistory)
	{
		iniwrite, 1, %inifile%, Settings, RememberHistory
		menu, s, ToggleCheck, Remember Changed Folder History
		GuiControl,show,hashistory
	}
else
	{
		iniwrite, 0, %inifile%, Settings, RememberHistory
		GuiControl,hide,hashistory
	}

Return
MakeStartLink:
If FileExist(Startlink)
{
    FileDelete,%startlink%
    iniwrite, Deleted, %inifile%, Settings, StartLinkCreated
}
else
{
    FileCreateShortcut, %A_ScriptFullPath%, %A_StartMenu%\Programs\%ScriptName%.lnk,%A_scriptdir%,,%Description%,%trayicon%,,0
    iniwrite, 1, %inifile%, Settings, StartLinkCreated ;; todo, read for link for broken\changed path. remove it that happens.
}
return
ForceApplyNOWtoggle:
ForceApplyNOW := !ForceApplyNOW
if (ForceApplyNOW)
	{
		iniwrite, 1, %inifile%, Settings, ForceApplyNOW
		menu, s, ToggleCheck,  ** Always Force Windows to Apply New Icons on Save
		GuiControl,,forcewindownsreload,1
	}
else
	{
		iniwrite, 0, %inifile%, Settings, ForceApplyNOW
		menu, s, ToggleCheck,  ** Always Force Windows to Apply New Icons on Save
		GuiControl,,forcewindownsreload,0
	}
Return


togautoclipboard:
AutoCheckClipboard4Path := !AutoCheckClipboard4Path
if (AutoCheckClipboard4Path)
	{
		iniwrite, 1, %inifile%, Settings, AutoCheckClipboard4Path
		menu, s, togglecheck, Auto check for folder path in clipboard on startup
	}
else
	{
		iniwrite, 0, %inifile%, Settings, AutoCheckClipboard4Path
		menu, s, togglecheck, Auto check for folder path in clipboard on startup
	}
return

dllmsgbox:

dllwarning =
(

This file is not a .ico

This tool was written with the simplicity, ease and speed .ico files in mind. I recommend them here. I have NOT fully tested using .dll files. `(And currently don't plan on it either.`)

It can obviously, and in most casees, will work to apply .dll's, .exe's and .icl's, Windows does it all the time for most of its system folders.

HOWEVER! These File Types require an additional IconIndex or IconResource # assigned to them.

The "Override IconIndex #" checkbox will allow you to assign a custom Index# to the end of IconResource. `(The default is 0 which is what an existing .ico file.`)

It will be written like this in the desktop.ini file.
IconResource=C:\path to\your.dll,`(your index #`)

** THIS IS EXPERIMENTAL !! This may apply the wrong icon !! ** Continue at your own risk. **

An error, the wrong icon being applied, is fairly harmless, more-so annoying if you need to Re-Set a desktop.ini

You've Been Warned!

)

MsgBox, 262144, - Change Folder .Ico - ? Non-ico Warning ?,  %dllwarning%

return



helloandwelcome:
guicontrol,,folderpath,%a_scriptdir%
gosub loadfolderpath
sleep 300
guicontrol,,iconpath,%a_scriptdir%\Icons\ChangeFolderIcon.ico
gosub PreviewIcon
guicontrol,,forcewindownsreload,0
guicontrol,,allowTTB,1
guicontrol,enable,infotip,
guicontrol,,infotip,%Description%

hellobox =

(
Thank for checking out - Change Folder .Ico -
It can %Description%.

-------------------------

It seems this is your first time running it, or you just reset your settings.ini file.

It was written to set ".ico" file paths into a folders desktop.ini file which Windows uses apply custom folder icons.

Other file types can be pushed through this tool BUT it has limited capability dealing with .dlls and .exes files.
The ICO Format works best here!

-------------------------

The Folder where the this Apps lives, and its icon, has been loaded into the GUI as an example. The icon has not been set yet. Click "Set New Icon" button or "Ctrl+S" to apply the icon to this folder!
Its Just about that Simple!

-------------------------

The F1 Hotkey will Show a Live Hotkeys \ Quick Actions Menu that Run most of the buttons and menu items from this GUI. You can customize them in the %a_scriptname%-SETTINGS.ini file.

If you have any questions not answered by the few info message boxes, (or find a bug), Visit the Github Webpage from the Settings Menu for more info.

Have Fun With Your New Folder Icons!!!

)

MsgBox, 4160, - Change Folder .Ico - Hello && Welcome !, %hellobox%

return


AlwaysOnTopToggle:
pinunpin:
; Gui, Add, CheckBox, hWndhpintip vpin gpinunpin +Checked x+15+m, Pin\Unpin to Top ;
global pin, pinFF, piNN, pinstartpic
gui, submit, nohide
if (pin)
	{
		Gui, -alwaysontop
		GuiControl,,pin,%pinFF%
		pin := 0
		tooltip, Unpinned!
	}
else
	{
		Gui, +alwaysontop
		GuiControl,,pin,%pinNN%
		pin := 1
		tooltip, Pinned to Top!
	}
SetTimer, RemoveToolTip, -2000
return

Pintoggle:
gui, submit, nohide
StartOnTop := !StartOnTop
if (StartOnTop)
	{
	IniWrite, 1, %inifile%, Settings, StartOnTop
	; WinSet, SubCommand, Value [, WinTitle, WinText, ExcludeTitle, ExcludeText]
	; WinSet, AlwaysOnTop, On,,Pin\Unpin From Top,Notepad++
	menu, s, ToggleCheck, Start Pinned to Top
	; GuiControl,,pin,1
		; GuiControl,,pin,%pinNN%
	
	}
else
	{
	IniWrite, 0, %inifile%, Settings, StartOnTop
	; WinSet, AlwaysOnTop, Off,,Pin\Unpin From Top,Notepad++
	menu, s, ToggleCheck, Start Pinned to Top
	; GuiControl,,pin,0
		; GuiControl,,pin,%pinFF%
	
	}
Return

pintotop:
; gui, add, picture, x+m w24 h24 vpin gxahksxguiPinToTop, %pinoff%
global pin, pinFF, piNN, pinstartpic
gui, submit, nohide
If pinstartpic = 1
{
	gui, submit, nohide
	sleep 10 
	GuiControl,,pin, %pinon%
	pinstartpic=2
	Gui, +alwaysontop
	tooltip, Pinned to Top!
	SetTimer, RemoveToolTip, -1500
	return
}
If pinstartpic = 2
{
	gui, submit, nohide
	GuiControl,,pin, %pinoff%
	pinstartpic=1
	Gui, -alwaysontop
	tooltip, Unpinned!
	SetTimer, RemoveToolTip, -1500
	return
}
Return










/*
    
    
    
    ---------------------------
Change Folder ICO.exe
---------------------------
Error:  Failed attempt to launch program or document:
Action: <ie4uinit.exe>
Params: <-show>

Specifically: The system cannot find the file specified.



	Line#
--->	1876: RunWait,ie4uinit.exe -show

The current thread will exit.
---------------------------
OK   
---------------------------

    */
    
    
    
BuildLiveFolderMenuFromEdit1:
Gui, submit, nohide

If !FileExist(folderpath)
{
    tip("Enter a Folder Path above first.",3000)
    return
}
folderpath := Trim(folderpath, "\")    ; Also remove trailing backslash to be safe
SplitPath,folderpath,,,,,dv
if (folderpath = dv)
{
    tip("Sorry windows cannot handle showing a live folder menu at a drive level.`nOperation Canceled.", 3000)
    return
}
tooltip, Loading Live Folder Menu...`nIf this folder contains a large about of files`nThis may freeze. Reload the app if that happens.
ShowLiveFolderMenu:
global filecount := ""

topmenu := Folderpath
SplitPath, topmenu, n,d,,s,v
LastMenu := TopMenu
Menu, %TopMenu%, add
Menu, %TopMenu%, deleteall
menu, %topmenu%, add, %v%\..\%n%`tOpen, OpenTopMenuHeader
menu, %topmenu%, icon, %v%\..\%n%`tOpen, %icons%\foldertree2.ico,,32
menu, %topmenu%, Default, %v%\..\%n%`tOpen
menu, %topmenu%, add, ; line -------------------------

; Loop, %topmenu%\*.*, 2,1 ;; folder loop
; {

    ; If InStr(A_LoopFileAttrib, "H") or InStr(A_LoopFileAttrib, "S")
        ; Continue

    ; Menu, %A_LoopFileDir%, Add, %A_LoopFileName% , runlibAction
	; Menu, %A_LoopFileDir%, Icon, %A_LoopFileName%, % GetFileIcon(A_LoopFileFullPath)
	
    ; If (A_LoopFileDir != LastMenu) and (LastMenu != TopMenu)
    ; {
        ; AddMenu(LastMenu)
    ; }

    ; LastMenu := A_LoopFileDir
; }
Loop, %topmenu%\*.*, 2,1 ;; folder loop
{
    If InStr(A_LoopFileAttrib, "H") or InStr(A_LoopFileAttrib, "S")
        Continue

    ; prescan - skip folders with no valid icon files
    hasValidFile := false
    Loop, %A_LoopFileFullPath%\*.*, 0, 0
    {
        SplitPath, A_LoopFileFullPath,,, ext
        if (ext = "ico") or (ext = "exe") or (ext = "dll") or (ext = "icl") or (ext = "ini")
        {
            hasValidFile := true
            break
        }
    }
    if !hasValidFile
        Continue
    ; relaIcon := GetFileIcon(A_LoopFileFullPath)
    Menu, %A_LoopFileDir%, Add, %A_LoopFileName%, runlibAction
    Menu, %A_LoopFileDir%, Icon, %A_LoopFileName%, % GetFileIcon(A_LoopFileFullPath),,%is%
    ; Menu, %A_LoopFileDir%, Icon, %A_LoopFileName%, %relaIcon%,,%is%

    If (A_LoopFileDir != LastMenu) and (LastMenu != TopMenu)
        AddMenu(LastMenu)
    LastMenu := A_LoopFileDir
}
Menu, %topmenu%, add, ; ;-------------------------

;; this live menu its loading too many file, how to i have only show these extension, can the dir from above not be added to the menu it on of these ext dose not exit within it?
;; if (e="ico") or (e="png") or (e="exe") or (e="dll") or (e="icl") or (e = "jpeg") or (e = "ini")
Loop, %topmenu%\*.*, 0,1 ;; files loop
{

    ; If InStr(A_LoopFileAttrib, "H") or InStr(A_LoopFileAttrib, "S") ;; not hiding hidden or system files, as the icons and desktop.ini will be hidden and system, making them uN_acceable to the menu
        ; Continue
        
    SplitPath, A_LoopFileFullPath,,, ext
    if (ext != "ico") and (ext != "exe") and (ext != "dll") and (ext != "icl") and (ext != "ini")
    Continue

    if (filecount >= LiveFolderMaxFilesCount)
    {
        filecount++ ; still count so the warning triggers
        Continue
    }
    
filecount++
tip("FileCount=" filecount "`nLoading Live Folder Menu`nThis may hang with large file counts.")
    
    ; relaIcon := GetFileIcon(A_LoopFileFullPath)
    Menu, %A_LoopFileDir%, Add, %A_LoopFileName% , runlibAction
	Menu, %A_LoopFileDir%, Icon, %A_LoopFileName%, % GetFileIcon(A_LoopFileFullPath),,%is%
	; Menu, %A_LoopFileDir%, Icon, %A_LoopFileName%, %relaIcon%,,%is%
	
    If (A_LoopFileDir != LastMenu) and (LastMenu != TopMenu)
    {
        AddMenu(LastMenu)
    }

    LastMenu := A_LoopFileDir
}
Menu, %topmenu%, add, ; line -------------------------

if (fileCount > LiveFolderMaxFilesCount) ; || folderCount > MaxFiles) ; Add a note if MaxFiles limits were reached ;; %A_ScriptDir%\xinc
{
    Menu, %topmenu%, Add, (Some items not shown`, over %LiveFolderMaxFilesCount% limit), DoNothing
    Menu, %topmenu%, Icon, (Some items not shown`, over %LiveFolderMaxFilesCount% limit), %icons%\attention.ico,,%is%
    menu, %topmenu%, Default, (Some items not shown`, over %LiveFolderMaxFilesCount% limit)
}

Menu, %topmenu%, add, File Count = %filecount%, dummy
Menu, %topmenu%, disable, File Count = %filecount%
AddMenu(LastMenu)
tooltip
Menu, %TopMenu%, Show, 10,10
Return

OpenTopMenuHeader:
run, %topmenu%
return
runlibAction:
item := A_ThisMenu . "\" . A_ThisMenuItem
SplitPath, item, n,d,e,s
if (n = "desktop.ini")
{
    try, run, %item%
    return
}
if (e="ico") or (e="png") or (e="exe") or (e="dll") or (e="icl")
{
    ; Relative := GetRelativePath(folderpath, item)
; GuiControl,, Edit2, %Relative%

; StringReplace, Relative, item, %folderpath%\, , 1
Relative := SubStr(item, StrLen(folderpath) + 2)


GuiControl,, Edit2, %Relative%
;; to use full path.
    ; GuiControl,, IconPath, %item%    ; Update Icon Path (modify if needed)
    gosub PreviewIcon
}
; Run, % A_ThisMenu . "\" . A_ThisMenuItem
Return

; icon set 1
 ; GetFileIcon(File) {
 ; global iconerror
    ; VarSetCapacity(FileInfo, A_PtrSize + 688)
    ; Flags := 0x101  ; SHGFI_ICON and SHGFI_SMALLICON
    ; if DllCall("shell32\SHGetFileInfoW", "WStr", File, "UInt", 0, "Ptr", &FileInfo, "UInt", A_PtrSize + 688, "UInt", Flags) {
        ; return "HICON:" NumGet(FileInfo, 0, "UPtr")
    ; }
    ; return %iconerror%     ; return A_AhkPath
; }

AddMenu(MenuName) ;; function for building live menu
{
    SplitPath, MenuName , DirName, OutDir, OutExtension, OutNameNoExt, OutDrive
    Menu, %OutDir%, Add, %DirName%, :%MenuName%
}
GetRelativePath(FromPath, ToPath)
{
    FromPath := RTrim(FromPath, "\")
    ToPath   := RTrim(ToPath, "\")

    StringLower, FromPath, FromPath
    StringLower, ToPath, ToPath

    ; Split paths into arrays
    FromArr := StrSplit(FromPath, "\")
    ToArr   := StrSplit(ToPath, "\")

    ; Find common root
    i := 1
    while (FromArr[i] = ToArr[i])
        i++

    ; Build ..\..\ part
    rel := ""
    Loop % FromArr.Length() - i + 1
        rel .= "..\"

    ; Add remaining target folders
    Loop % ToArr.Length() - i + 1
        rel .= ToArr[i + A_Index - 1] "\"

    return RTrim(rel, "\")
}




SaveDINI:
tip("Coming soon...",2000)
return

ShowInsertIconListView:
If !FileExist(xdm)
    Return
Run, %xdm% %A_thislabel%
return







; #Include %A_ScriptDir%\changedriveiconGUI.ahk
;---------------------------------------------------------------------------
ShowDriveMenu:
coordmode, menu, client
Menu, dl, UseErrorLevel, on
Menu, dl, add
Menu, dl, deleteall
; Menu, dl, add, Set Icon To Drive, ShowDriveMenu
Menu, dl, add, Set Icon To Drive ** READ ME, ChangeDriveIconMsgBox
Menu, dl, Icon, Set Icon To Drive ** READ ME, %icons%\driveseticon.ico,,%is%
Menu, dl, default, Set Icon To Drive ** READ ME
if !(A_IsAdmin)
{
    menu, dl, add, Run as Admin`t%RunAsAdmin%, RunAsAdmin
	menu, dl, icon, Run as Admin`t%RunAsAdmin%, %Icons%\admin.ico,,%is%
}
Menu, dl, add, ; line -------------------------
drives := []
DriveGet, driveList, List
; box(driveList)
Loop, Parse, driveList
{
    driveLetter := A_LoopField ":"
    arinf := driveletter "\autorun.inf"
    ; box(driveletter A_nl arinf)
    DriveGet, label, Label, %driveLetter%
    DriveGet, driveType, Type, %driveLetter%
    if (driveType = "Fixed") || (driveType = "Removable") ;; only hadd fro fixed and removale, not messing with unknown
    {
        If FileExist(arinf)
        {
            iniread, icon, %arinf%, autorun, icon
            iniread, Userlabel, %arinf%, autorun, label
        }
        aricon := driveletter "\" icon
        ; If FileExist(aricon)
            ; box(aricon)
 
        ; displayText := driveLetter "\ [" driveType "]"
        displayText := driveLetter "\ [" label "]"
        if (label = "") && (userlabel != "")
            displayText := driveLetter "\ [" userlabel "]"
            
        Menu, dl, add, %displayText%, pickeddrive
        
        If FileExist(aricon)
            Menu, dl, icon, %displayText%, %aricon%,,%is%
        else
            Menu, dl, icon, %displayText%, %icons%\drive.ico,,%is%
    }
    ; drives.Push(displayText) ;; 4 ddl
}
; Menu, dl, add, ** READ ME 1st **, ChangeDriveIconMsgBox
; Menu, dl, default, ** READ ME 1st **
; Menu, dl, Icon, ** READ ME 1st **, %icons%\about.ico,,%is%
Gui, submit, nohide
if (Folderpath != "")
{
    If FileExist(folderpath)
    {
        SplitPath, folderpath, dn,dd,de,ds,dv
        if (folderpath = dv)
        {
            Menu, dl, add, ; line -------------------------
            Menu, dl, add, .Mods., ShowDriveMenu
            Menu, dl, Icon, .Mods., %icons%\info.ico,,%is%
            ; Menu, dl, add, #TODO-Soon`t-d,ShowDriveMenu
            ; guicontrolget, currentFolderpath,, folderpath
            ; Menu, dl, add, %currentFolderpath%`tcfp, dummy
            
            Menu, dl, add, %folderpath%`tfp-d, ShowDriveMenu
            Menu, dl, disable, %folderpath%`tfp-d
        }
    }
}
Menu, dl, UseErrorLevel, off
Menu, dl, show, 10,10
return
runthismenuitem:
run, %A_thismenuitem%
return

ChangeDriveIconMsgBox:
Box("- Set Icon to Drive -`n`nTo Set Drive Icons the app needs to be running as Admin.`n`nTo set an icon to a Drive the .ico file *MUST* be local on the drive. Thus this Operation will *Copy* the icon and create a autorun.inf file to the root of the chosen drive. eg`, C:\autorun.inf & C:\Your Icon.ico - (Which Requires Admin Access). Icons for Hard Drive are limited to .ico format ONLY!.`n`nRe-Booting your system is required before the icon will be seen. *NOTE* Some Windows 11 PCs running a NPU might ignore the custom icon`, because Windows is a pain like that.`n`nAdditionally`, Should you want to manually revert this later the autorun.inf and copied icon will require Admin elevation to deleted. They will be hidden by default.`n`nYou've been informed!`n`nOn a side note I`, the dev`, have 8+ HDDs\SDDs in my system and have set custom icons to each one without issue.")
return

pickeddrive:
menuPicked := A_thismenuitem
; box(menuPicked) ;; S:\ [GAME DL]
drivepath := trim(RegExReplace(menupicked, "\\.*$"))
guicontrol,,folderpath,%drivepath%
gosub loadFolderPath ;; need to now look for autorun.inf
return


CleanOLDSections:
iniread, sections, %desktopini%      ; box(desktopini A_nl sections)
Loop, parse, sections, `n, `r
{
    Sec := A_LoopField
    if instr(sec, ".OLD.")
        IniDelete, %desktopini%, %sec%     ;  box(desktopini A_nl sec)
}
sleep 150
guicontrol,,allowDELINI,0
gosub loadFolderPath
return


CopyDopusButtonCode:
; bcode =
; (
; @nodeselect
; @async:"%A_ScriptDir%\ChangeFolderIcon.exe" {filepath}
; )
bcode =
(
<?xml version="1.0"?>
<button backcol="none" display="icon" hotkey_label="yes" label_pos="right" textcol="none">
	<label>Change Folder Icon</label>
	<icon1>%A_scriptdir%\ChangeFolderIcon.exe,-159</icon1>
	<function type="normal">
		<instruction>// @disablenosel:dirs</instruction>
		<instruction>// @dirsonly</instruction>
		<instruction />
		<instruction>@nodeselect</instruction>
		<instruction>@async:&quot;%A_ScriptDir%\ChangeFolderIcon.exe&quot; {filepath}</instruction>
		<instruction />
		<instruction>// https://resource.dopus.com/t/command-for-changing-folder-icon/51924</instruction>
		<instruction>// https://resource.dopus.com/t/change-folder-ico/54858</instruction>
		<instruction>// https://github.com/indigofairyx/Change-Folder-Icon</instruction>
	</function>
</button>
)
clipboard := ""
sleep 40
; clipboard := "@nodeselect`n@async:`"" A_ScriptDir "\ChangeFolderIcon.exe`" {filepath}"
clipboard := bcode
clipwait,0.5
If (clipboard != "")
{
    Tooltip Copied: %clipboard%
    SetTimer, RemoveToolTip, -1000
}
MsgBox, 262208, -Dopus Button - CFI -, The .dcf CLI (In xml formate) for using Change Folder Icon has been Copied to your clipboard. Put Dopus into Customize Mode then paste it onto your toolbar or menu of choice.`n`nYou can send any Folder and Files.`nWhen sent`, Directories will be loaded into the folder path field. Files will be split at the parent dir which will load its the folder path. With the exception of .ico's they are sent to the icon path.`n`nThe button is using the path where you're running this app from right now. If you move you'll have to manually update the Dopus Button.
return

ToggleHideLocalIco:
HideLocalIco := !HideLocalIco
if (HideLocalIco)
    iniwrite, 1, %inifile%, Settings, HideLocalIco
else
    iniwrite, 0, %inifile%, Settings, HideLocalIco
return
ToggleCopyIcoToDest:
CopyIcoToDest := !CopyIcoToDest
if (CopyIcoToDest)
{
    IniWrite, 1, %inifile%, Settings, CopyIcoToDest
    guicontrol,Enable,HideLocalIco
}
else
{
    IniWrite, 0, %inifile%, Settings, CopyIcoToDest
    guicontrol,Disable,HideLocalIco
}
return

; -[--- End of X:\AHK\xINC\ChangeFolderIcon\ChangeFolderIcon.ahk ---]-
