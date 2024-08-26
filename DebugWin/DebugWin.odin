package debugwin

import w "core:sys/windows"
import str "core:strings"
import "core:fmt"

hwin	:w.HWND
hedt	:w.HWND

SavageEDClass	:cstring = "SavageEDClass"
RichEditClass	:cstring = "RichEdit20A"

MAX_SIZE		:: 5000
cbuffer			:str.Builder
cls_str			:cstring = ""
initialized		:bool

find_window :: proc() -> bool {

	if !initialized do return false
	hwin = w.FindWindowA(SavageEDClass, nil)
	if hwin == nil do return false
	hedt = w.FindWindowExA(hwin, nil, RichEditClass, nil )
	if hedt == nil do return false
	return true
}

init :: proc() -> bool {
	
	initialized = true
	if !find_window() {
		initialized = false
		return false
	}
	str.builder_init_len_cap(&cbuffer, 0, MAX_SIZE)
	return true
}

deinit :: proc() {
	if initialized {
		str.builder_destroy(&cbuffer)
		initialized = false
	}
}

cls :: proc() ->bool {
	find_window() or_return
	w.SendMessageA(hedt, w.WM_SETTEXT, 0, transmute(int)cls_str )
	return true
}

write :: proc( args: ..any, sep:= " " ) ->bool {

	find_window() or_return
	str.builder_reset(&cbuffer)
	fmt.sbprint( &cbuffer, ..args)
	cstr := str.to_cstring(&cbuffer)
	w.SendMessageA(hedt, w.EM_REPLACESEL, 1, transmute(int)cstr )
	return true
}

writeln :: proc( args: ..any, sep:= " " ) -> bool {

	find_window() or_return
	str.builder_reset(&cbuffer)
	fmt.sbprintln( &cbuffer, ..args)
	cstr := str.to_cstring(&cbuffer)
	w.SendMessageA(hedt, w.EM_REPLACESEL, 0, transmute(int)cstr )
	return true
}


