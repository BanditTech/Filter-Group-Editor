LoadJSON(path){
	Try {
		Return JSON.Load(FileOpen(path,"R").Read())
	} Catch e {
		MsgBox % "Issue loading the JSON path" . ErrorMsg(e)
		Return False
	}
}

SaveJSON(Obj,path){
	Try {
		JSONtext := ReformatJSON(JSON.Dump(Obj,,2))
		If FileExist(path)
			FileDelete, %path%
		FileAppend, %JSONtext%, %path%
		Return JSONtext
	} Catch e {
		MsgBox % "Issue saving the JSON file" . ErrorMsg(e)
		Return False
	}
}

ErrorMsg(e){
	Return "`n"
	. "Msg: " e.Message "`n"
	. "What: " e.What "`n"
	. "Extra: " e.Extra "`n"
	. "File: " e.File "`n"
	. "Line: " e.Line "`n"
}

PrintoutKeys(obj,depth:=0){
	txt := ""
	For k, v in obj {
		if IsObject(v) {
			txt .= (!Obj["GroupType"]?"`n":" ") spacestr(depth) k " : {" PrintoutKeys(v,depth+1)( obj["GroupType"] ? "`n" spacestr(depth) : " " )"}"
		} Else {
			txt .= " " k ":" v ","
		}
	}
	txt := RTrim(txt, ",")
	If (depth==0)
		txt := "{ " txt " }"
	Return txt
}

SpaceStr(num,spacing := " "){
	str := ""
	loop % num
		str .= spacing
	return str
}

DeepClone(Array, Objs=0){
	if !Objs
		Objs := {}
	Obj := Array.Clone()
	Objs[&Array] := Obj ; Save this new array
	For Key, Val in Obj
		if (IsObject(Val)) ; If it is a subarray
			Obj[Key] := Objs[&Val] ; If we already know of a refrence to this array
			? Objs[&Val] ; Then point it to the new array
			: DeepClone(Val,Objs) ; Otherwise, clone this sub-array
	return Obj
}

ReformatJSON(String){
  String := RegExReplace(String, "O`am)(?<!\])(?<!\],)\n *("".*""\: [\d""])", " $1")
  String := RegExReplace(String, "O`am)(?<!\])(?<!\],)(?<!\})\n *(\})", " }")
  String := RegExReplace(String, "O`am)\n *(""~ElementList"")", " $1")
  String := RegExReplace(String, "O`am) *\]\n( *)\}", "$1]}")
  Return String
}
