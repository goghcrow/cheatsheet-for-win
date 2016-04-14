; 泪奔%>_<%, 只有AutoHotkeyA32.exe这个版本可以运行
; 估计是DllCall类型或者wstr,uint64什么的
; 还有你妹给方法加中文注释就无法运行.....
; @author xiaofeng
; TODO:
; 重写菜单的过滤
; 做个靠谱的界面,win窗体或者html
; 想办法处理非原生窗口控件

#SingleInstance, force
SetBatchLines -1

_getMenuString(_hMenu, nPos) {
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
	if (_hMenu == -1) {
		_hWnd := WinExist("A")
		_hMenu := DllCall("user32\GetMenu","UInt", _hWnd)
	}

	items := []
	itemCount := DllCall("user32\GetMenuItemCount", "Uint", _hMenu)
	Loop % itemCount {
		nPos := A_Index-1
		lpString := _getMenuString(_hMenu, nPos)
		if(!lpString) {
			Continue
		}
		items[nPos] := {text: lpString, items: []}
		hSubMenu := DllCall("user32\GetSubMenu", "UInt", _hMenu, "Int", nPos)
		if (hSubMenu != 0) {
			items[nPos].items := getMenus(hSubMenu)
		}
	}
	return items
}

getTitle() {
	_hWnd := WinExist("A")
	WinGetTitle, title, ahk_id %_hWnd%
	return title
}

isHoldOn(key, millisecond, period := 50) {
	duration := 0
	while true {
		sleep % period
		if (GetKeyState(key, "P")) {
			duration += period
			if (duration >= millisecond) {
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

getHwnd() {
	MouseGetPos, , , , hwnd, 2
	return hwnd
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
		column =
		for _k, _v in v.items {
			; if _v.text contains Ctrl,Alt {
			if InStr(_v.text, "Ctrl") || InStr(_v.text, "Alt") || InStr(_v.text, "Shift") {
				column .= _v.text
				column .= A_Tab
			}
		}
		if column {
			str .= "##" . v.text . "##`n" . column
			str .= "`n`n"
		}
	}
	title := getTitle()
	if (str) {
		Progress, B C0 ZH0 FM11 FS10 W800 CWFFFFFF, % str, CheatSheet FOR [%title%], , Microsoft YaHei
	} else {
		TrayTip, NOT FOUND, CheatSheet
	}
	if (isRelease("LWin")) {
		Progress, Off
	}
}
return
