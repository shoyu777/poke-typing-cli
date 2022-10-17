import std/strutils
import widget
import widget_util

type BorderWidget = ref object of Widget
  hidden: bool

func newBorderWidget*(hidden: bool = false): BorderWidget =
  return BorderWidget(hidden: hidden)

method render*(self: BorderWidget) =
  if not self.hidden:
    stdout.write("├" & "─".repeat(DEFAULT_SCREEN_WIDTH - 2) & "┤\n")