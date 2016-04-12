; 泪奔%>_<%, 只有AutoHotkeyA32.exe这个版本可以运行
; 估计是DllCall类型或者wstr,uint64什么的
#SingleInstance, force
SetBatchLines -1


getMenuString(_hMenu, nPos) {
	len := DllCall("user32\GetMenuString"
		, "UInt", _hMenu
		, "UInt", nPos
		, "Uint", 0 ; NULL
		, "Int", 0  ; get length
		, "UInt", 0x0400) ;MF_BYPOSITION
	VarSetCapacity(lpString, len + 1)
	len := DllCall("user32\GetMenuString"
		, "UInt", _hMenu
		, "UInt", nPos
		, "Str", lpString
		, "Int", len + 1
		, "UInt", 0x0400)
	return (len > 0 && Trim(lpString)) ? Trim(lpString) : ""
}

getMenus(_hMenu := -1) {
	if(_hMenu == -1) {
		_hWnd := WinExist("A")
		_hMenu := DllCall("user32\GetMenu","UInt", _hWnd)
	}

	items := []
	itemCount := DllCall("user32\GetMenuItemCount", "Uint", _hMenu)
	Loop % itemCount
	{
		nPos := A_Index-1
		lpString := getMenuString(_hMenu, nPos)
		if(!lpString) {
			Continue
		}
		items[nPos] := {text: lpString, items: []}
		hSubMenu := DllCall("user32\GetSubMenu", "UInt", _hMenu, "Int", nPos)
		if(hSubMenu != 0) {
			items[nPos].items := getMenus(hSubMenu)
		}
	}
	return items
}


isHoldOn(key, millisecond, period := 50) {
	duration := 0
	while true {
		sleep % period
		if(GetKeyState(key, "P")) {
			duration += period
			if(duration >= millisecond) {
				return true
			}
		} else {
			return false
		}
	}
}

isRelease(key, period := 50) {
	while GetKeyState(key, "P") {
		sleep % period
	}
	return true
}

~LWin::
StringCaseSense, Off
if(isHoldOn("LWin", 1000)) {
	menu := getMenus()
	str =
	for k, v in menu {
		if(!v.items.MaxIndex()) {
			Continue
		}
		for _k, _v in v.items {
			; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ FIXME
			; if _v.text contains Ctrl,Alt {
			if InStr(_v.text, "Ctrl") || InStr(_v.text, "Alt") {
				str .= _v.text . "`n"
			}
		}

	}
	; ToolTip, "~"
	; TrayTip, "", % str
	; ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~GUI layout
	if str {
		Progress, B C0 ZH0 FS8 CWFFFFFF, % str, , , Microsoft YaHei
	}
	if isRelease("LWin") {
		Progress, Off
	}
}
return

