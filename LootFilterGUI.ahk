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

; Debug line to save output as seperate file
If Brain.SaveTestObj
	Brain.TestFilter := A_ScriptDir "\save\TestFilter.json" 

; Now we load into Memory the json object
Brain.Memory := LoadJSON( Brain.CurrentFilter )

; This object is the Filter.Group Class for the loaded JSON
Brain.SomethingLoaded := New Filter.Group(Brain.Memory)

; Now we build the GUI area for the group
Brain.GUI := New Filter.Gui(Brain.SomethingLoaded)

; From the GUI HWND we create a resizable scrolling zone
Brain.ScrollArea := New ScrollGUI(Brain.GUI.HWND, 600, 600, "+Resize +LabelScrollArea", 3, 4)
Brain.ScrollArea.Show("Loaded Filter", "ycenter xcenter")

; Print out the original Object, and the new object
If Brain.FinalObjMsg {
	MsgBox % PrintoutKeys(Brain.Memory)
	MsgBox % PrintoutKeys(Brain.SomethingLoaded)
}

; Save the object as a new file for viewing
If Brain.SaveTestObj
	MsgBox % SaveJSON(Brain.SomethingLoaded,Brain.TestFilter)

; End Of Auto Execute
return

#Include %A_ScriptDIR%\lib\Library.ahk