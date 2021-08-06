#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

Global Brain := {}
	Brain.GroupVerbose := False
	Brain.BuildVerbose := False
	Brain.ClickVerbose := False
	Brain.ErrorMsg := True
Brain.CurrentFilter := A_ScriptDir "\save\CurrentFilter.json" 
Brain.TestFilter := A_ScriptDir "\save\TestFilter.json" 
Brain.Memory := LoadJSON( Brain.CurrentFilter )

Global SomethingLoaded := New Filter.Group(Brain.Memory)

Global CLFgui := New Filter.Gui(SomethingLoaded)
Global ScrollArea := New ScrollGUI(CLFgui.HWND, 600, 600, "+Resize +LabelScrollArea", 3, 4)

ScrollArea.Show("Loaded Filter", "ycenter xcenter")

; MsgBox % PrintoutKeys(Brain.Memory)
; MsgBox % PrintoutKeys(SomethingLoaded)

; MsgBox % SaveJSON(SomethingLoaded,Brain.TestFilter)

; End Of Auto Execute
return

#Include %A_ScriptDIR%\lib\Library.ahk