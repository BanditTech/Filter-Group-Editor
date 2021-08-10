#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

; Make a global object for settings and data
Global Brain := {}
; Provide the location for the loaded file
Brain.CurrentFilter := A_ScriptDir "\save\CurrentFilter.json" 
; Debug settings
	Brain.GroupVerbose := False
	Brain.BuildVerbose := False
	Brain.ClickVerbose := False
	Brain.ErrorMsg := True
	Brain.FinalObjMsg := False
	Brain.SaveTestObj := False

; Add code to drop filter files onto script
If (A_Args[1]) {
	MsgBox % A_Args[1]
	If (FileExist(A_Args[1]) && A_Args[1] ~= ".json$") {
		Brain.CurrentFilter := A_Args[1]
	}
}

Filter.LoadFilter()

; End Of Auto Execute
return

#Include %A_ScriptDIR%\lib\Library.ahk