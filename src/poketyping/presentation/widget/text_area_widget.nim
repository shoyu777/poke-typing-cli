import
  std/strutils,
  widget,
  widget_util,
  wcwidth

type TextAreaWidget = ref object of Widget
  text: string
  row: int
  hidden: bool

func newTextAreaWidget*(text: string, row: int = 1, hidden: bool = false): TextAreaWidget =
  return TextAreaWidget(
    text: text,
    row: row,
    hidden: hidden
  )

method render*(self: TextAreaWidget) =
  if not self.hidden:
    let lines = self.text.split('*')
    for idx in 0 .. (self.row - 1):
      if lines.len > idx:
        stdout.write("│ " & lines[idx] & " ".repeat(DEFAULT_SCREEN_WIDTH - lines[idx].pureText.wcswidth - 3) & "│\n")
      else:
        stdout.write("│ " & " ".repeat(DEFAULT_SCREEN_WIDTH - 3) & "│\n")