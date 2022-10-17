import std/strutils
import widget
import widget_util

type FrameBottomWidget = ref object of Widget

func newFrameBottomWidget*(): FrameBottomWidget =
  return FrameBottomWidget()

method render*(self: FrameBottomWidget) =
  stdout.write("╰" & "─".repeat(DEFAULT_SCREEN_WIDTH - 2) & "╯\n")