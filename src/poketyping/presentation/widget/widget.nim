import std/terminal

type Widget* = ref object of RootObj

method render*(self: Widget) {.base.} =
  discard

proc screenReset*(self: Widget) =
  stdout.eraseScreen()
  stdout.setCursorPos(0,0)