ScrollAreaSize:
	Brain.ScrollArea.AdjustToChild()
Return

; Editor Labels
EDITEscape:
EDITClose:
	; Tooltip, fired
	Gui, Editor: Hide
	Gui, % Brain.ScrollArea.HWND ": -Disabled"
	Gui, CLFgui: -Disabled
	Winset, Top, ,% "ahk_id " Brain.ScrollArea.HWND
	WinActivate, %  "ahk_id " Brain.ScrollArea.HWND
Return

