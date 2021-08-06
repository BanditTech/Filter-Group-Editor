ScrollAreaSize:
	ScrollArea.AdjustToChild()
Return

; Editor Labels
EDITEscape:
EDITClose:
	; Tooltip, fired
	Gui, Editor: Hide
	Gui, % ScrollArea.HWND ": -Disabled"
	Gui, CLFgui: -Disabled
	Winset, Top, ,% "ahk_id " ScrollArea.HWND
	WinActivate, %  "ahk_id " ScrollArea.HWND
Return

