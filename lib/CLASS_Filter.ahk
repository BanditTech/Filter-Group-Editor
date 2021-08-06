Class Filter {
	static heightele := 24
	static heightgrp := 29
	Class Gui {
		__New(Obj){
			Gui, CLFgui: Destroy
			Gui, CLFgui: New, +LabelCLFgui +LastFound +HWNDHWND
			This.HWND := HWND + 0
	    Gui, Font, Bold s12 cBlack, Segoe UI
			This.Build(Obj,10)
			This.Add("Button", "xp y+45 w1 h1" ) ; Spacing button for Windows Task Bar
		}
		Show(){
			Gui, CLFgui: Show, AutoSize
			Return

			ScrollAreaEscape:
			ScrollAreaClose:
			CLFguiEscape:
			CLFguiClose:
				ExitApp
			Return
		}
		Add(ctype,opt:="",txt:=""){
			global
			Try {
			Gui, CLFgui: Add, %ctype%, %opt%, %txt%
			} Catch e {
				If Brain.ErrorMsg
					MsgBox % "Error adding element" . ErrorMsg(e)
				Return False
			}
		}
		Build(obj,x,depth:=0,listkey:=""){
			Static InitialWidth := 1200 
			if (obj.GroupType) {
				If Brain.BuildVerbose
					MsgBox % "obj.grouptype " obj.GroupType " x " x " depth " depth " listkey " listkey
				; Draw the box which will contain all sub-elements
				This.Add("GroupBox", "x" x + (depth*10) 
					. (listkey? " yp+" Filter.heightgrp - 2 : "ym")
					. " w" InitialWidth - (depth*15) 
					. " h" Filter.Group.GroupHeight(obj)
					; Here we have the text field with information about the group
					; First we add the type of group, and its Type Value (Count or Weight)
					, obj.GroupType  (obj.TypeValue && obj.GroupType ~= "Count|Weight" ? " = " obj.TypeValue " ":" ") 
						; Now we add additional information
						. (obj.Description?"""" obj.Description """ " :"")
						. (obj.StashTab? "Stash in: " obj.StashTab " ":""))
				; Add interactive button for this group element
				This.Add("Text", "xp yp wp h" Filter.heightgrp " gInteractMe BackgroundTrans vKEYDEPTH" listkey )
				If Brain.BuildVerbose
					MsgBox % "KEYDEPTH" listkey
				; Build all sub-elements within the list (recursively)
				For k, v in obj["~ElementList"] {
					This.Build(v,x,depth+1,listkey != "" ? listkey "_" k : k)
				}
				; Spacing button for alignment
				This.Add("Button", "xp yp+3 w1 h1" ) 
			} Else If (obj["#Key"]) {
				; Create the key entry text
				This.Add("Text", "x" x + (depth*10) " yp+" Filter.heightele " w" InitialWidth - (depth*15)
				, (obj["Weight"] != "" ? "Weight:" obj["Weight"] " `t" : "") 
				. obj["Type"] ":`t" obj["#Key"] " " obj["Eval"] " " obj["Min"] )
				If Brain.BuildVerbose
					MsgBox % "KEYDEPTH" listkey
				; Add interactive button for this element
				This.Add("Text", "xp yp wp hp gInteractMe BackgroundTrans vKEYDEPTH" listkey )
			}
		}
		Retreive(d){
			global SomethingLoaded
			d := LTrim(d,"KEYDEPTH")
			d := StrSplit(d, "_")
			val := SomethingLoaded
			For k, v in d {
				val := val["~ElementList"][v]
			}
			return val
		}
		ParentType(d){
			global SomethingLoaded
			d := LTrim(d,"KEYDEPTH")
			If (d = "")
				Return "TopLevel"
			d := RTrim(d,"1234567890")
			d := RTrim(d,"_")
			d := StrSplit(d, "_")
			val := SomethingLoaded
			For k, v in d {
				val := val["~ElementList"][v]
			}
			return val["GroupType"]
		}
	}
	Class Editor {
		Static SavedVariables := []
		__New(ctrl){
			Gui, Editor: Destroy
			Gui, Editor: New, +LabelEDIT +LastFound +HWNDHWND
			This.HWND := HWND + 0
			This.ParentType := Filter.Gui.ParentType(ctrl)
			This.ctrl := ctrl
	    Gui, Font, Bold s12 cBlack, Segoe UI
			; Create a reference to the current working object
			This.obj := Filter.Gui.Retreive(ctrl)
			; Create a backup of the original object settings
			This.old := This.obj.Clone()
			If Brain.ClickVerbose {
				ToolTip % "Parent Type is " This.ParentType
				MsgBox % PrintoutKeys(This.obj)
			}
			This.Build(This.obj)
			This.Show()
			This.hToolbar := This.CreateToolbar()
		}
		Build(Obj){
			Gui  Font, Bold s10 cBlack, Segoe UI
			If Obj["GroupType"] {
				DisableThreshold := Obj["GroupType"] = "And" || Obj["GroupType"] = "Not" 
				DisableWeight := This.ParentType = "And" || This.ParentType = "Not" || This.ParentType = "TopLevel" 
				DisableStashTab := !( This.ParentType = "TopLevel" )

				This.Add("GroupBox", "x16 y8 w105 h55 +Center Section", "Group Type")
				This.Add("ComboBox", "xp+8 ys+24 w89", Obj["GroupType"] "||And|Not|Count|Weight")

				This.Add("GroupBox", "xs+130 ys w105 h55 +Center", "Threshold")
				This.Add("Edit", "xp+8 ys+24 w89 h25" (DisableThreshold?" +Disabled":""))
				This.Add("UpDown", "xp+72 ys+24 w18 h25"  (DisableThreshold?" +Disabled":"") , Obj["TypeValue"] != "" ? Obj["TypeValue"] : "1")

				This.Add("GroupBox", "xs+260 ys w105 h55 +Center", "Weight")
				This.Add("Edit", "xp+8 ys+24 w89 h25" (DisableWeight?" +Disabled":""))
				This.Add("UpDown", "xp+72 ys+24 w18 h25" (DisableWeight?" +Disabled":""), (Obj["Weight"] != ""?Obj["Weight"]:"1"))

				This.Add("GroupBox", "xs+390 ys w105 h55 +Center", "Stash Tab")
				This.Add("Edit", "xp+8 ys+24 w89 h25" (DisableStashTab?" +Disabled":""))
				This.Add("UpDown", "xp+72 ys+24 w18 h25" (DisableStashTab?" +Disabled":""), (Obj["StashTab"] != ""?Obj["StashTab"]:""))

				This.Add("GroupBox", "xs ys+64 w495 h55 +Center Section", "Description / Group Name")
				This.Add("Edit", "xs+8 ys+24 w479 h25", (Obj["Description"]!=""?Obj["Description"]:""))

				This.Add("Text", "xm y+14 h15", "") ; Blank text to allign toolbar

			} Else If Obj["#Key"]{
				This.Add("GroupBox","x8 ym w505 h55 +Center  Section","Parsed Affix Text or Property Name")
				This.Add("ComboBox","xs+8 ys+22 w491 h23 r4", Obj["#Key"] "||Insert|Choices|Later")

				This.Add("GroupBox", "x8 ys+56 w161 h55 +Center  Section", "Evaluation Method")
				This.Add("DropDownList", "xs+8 ys+22 w145 h23 r9", Obj["Eval"] "||>=|>|=|!=|<|<=|~|~=")

				This.Add("GroupBox", "xs+172 ys w161 h55 +Center  Section", "Key Type")
				This.Add("DropDownList", "xs+8 ys+22 w145 h23 r3", Obj["Type"] "||Prop|Affix")

				This.Add("GroupBox", "xs+172 ys w161 h55 +Center  Section", "Weight")
				This.Add("Edit", "xs+8 ys+22 w141 h23")
				This.Add("UpDown", "x+1 hp range-1000-1000", Obj["Weight"])

				This.Add("GroupBox", "x8 ys+56 w505 h55 +Center  Section", "Comparison Value")
				This.Add("Edit", "xs+8 ys+22 w491 h23", Obj["Min"])

				This.Add("Text", "xm y+14 h15", "") ; Blank text to allign toolbar


			}
			Gui  Font
		}
		Add(ctype,opt:="",txt:=""){
			global
			Try {
			Gui, Editor: Add, %ctype%, %opt%, %txt%
			} Catch e {
				If Brain.ErrorMsg
					MsgBox % "Error adding element" . ErrorMsg(e)
				Return False
			}
		}
		CreateToolbar() {
				ImageList := IL_Create(10)
				IL_Add(ImageList, "shell32.dll", 86)
				IL_Add(ImageList, "shell32.dll", 7)
				IL_Add(ImageList, "shell32.dll", 259)
				IL_Add(ImageList, "shell32.dll", 240)
				IL_Add(ImageList, "shell32.dll", 247)
				IL_Add(ImageList, "shell32.dll", 248)
				IL_Add(ImageList, "shell32.dll", 110)

				Buttons = 
				(LTrim
						Import
						Export
						-
						&Save
						Reset
						-
						Move Up
						Move Down
						-
						Remove
				)

				Return ToolbarCreate("OnToolbar", Buttons, ImageList, "Flat List ShowText Bottom Tooltips",,"xm yp w505")
		}
		Show(){
			Gui, Editor: Show, Autosize
			Return
		}
		Destroy(){
			Gui, Editor: Destroy
		}
	}
	Class Group {
		__New(options:=""){
			For k, v in options
				This[k] := IsObject(v) ? DeepClone(v) : v
			If !This.HasKey("GroupType")
				This["GroupType"] := "And"
			If (!This.HasKey("~ElementList") || !IsObject(This["~ElementList"]))
				This["~ElementList"] := []
			Return This
		}
		Add(that,index:=""){
			If (index != "")
				This["~ElementList"].InsertAt(index, that)
			Else
				This["~ElementList"].Push(that)
		}
		Remove(index){
			return This["~ElementList"].RemoveAt(index)
		}
		GetCount(Obj:=""){
			groupc := elementc := 0
			If (Obj = "")
				Obj := This
			For k, v in Obj["~ElementList"] {
				If (v.GroupType != ""){
					groupc++
					val := This.GetCount(v)
					groupc += val.gc
					elementc += val.ec
				} Else If (v["#Key"] != "") {
					elementc++
				}
			}
			Return {gc:groupc,ec:elementc}
		}
		GroupHeight(Obj:=""){
			If (Obj = "")
				Obj := This
			Vals := This.GetCount(Obj)
			If Brain.GroupVerbose
				MsgBox % "groups " Vals.gc " elements " Vals.ec
			Return ( (Filter.heightgrp + 1 ) * (Vals.gc + 1) + Filter.heightele * Vals.ec )
		}
	}
	Class Element {
		__New(options){
			for k, v in ["#Key","Eval","Min","Type"]
				This[v] := ""
			For k, v in options
				This[k] := v
			Return This
		}
	}
}

OnToolbar(hWnd, Event, Text, Pos, Id) {
    If (Event != "Click") {
        Return
    }

    If (Text == "Import") {
			MsgBox % "Import" IsObject(Filter.Editor.obj)
    } Else If (Text == "Export") {
			MsgBox % "Export"

    } Else If (Text == "&Save") {
			MsgBox % "Save"

    } Else If (Text == "Reset") {
			MsgBox % "Reset"

    } Else If (Text == "Move Up") {
			MsgBox % "Move Up"

    } Else If (Text == "Move Down") {
			MsgBox % "Move Down"

    } Else If (Text == "Remove") {
			MsgBox % "Remove"

    }
}

InteractMe(){

	Editor := New Filter.Editor(A_GuiControl)
	Winset, Top, ,% "ahk_id " Editor.HWND
	Gui,% ScrollArea.HWND ": +Disabled"
	Gui, CLFgui : +Disabled
}