type Widget* = ref object of RootObj

method render*(self: Widget) {.base.} =
  discard