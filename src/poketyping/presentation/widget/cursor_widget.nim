import
  widget,
  std/terminal

type CursorWidget* = ref object of Widget
  posX: int
  posY: int

func newCursorWidget*(posX, posY: int): CursorWidget =
  return CursorWidget(posX: posX, posY: posY)

method render*(self: CursorWidget) =
  stdout.setCursorPos(self.posX, self.posY)
