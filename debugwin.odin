package main

import dbg "DebugWin"
import w "core:sys/windows"
import str "core:strings"

import "core:fmt"

bytes	:[]byte = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }

main :: proc() {
	
	ok := dbg.init()
	if !ok do fmt.println ("Could not find open window of SavageEd.exe")
	defer dbg.deinit()

	dbg.cls()
	dbg.write("Hellope")
	dbg.write(" World\n")
	dbg.writeln("2nd line")
	dbg.writeln("Bytes :", bytes)
}
