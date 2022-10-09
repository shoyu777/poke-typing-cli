type KEYCODE* {.pure.} = enum
  CTRL_C = "\u0003"
  ESCAPE = "\u001B"
  BACKSPACE = "\u007f"

type COLORS* {.pure.} = enum
  BG_GREEN = "\x1b[42m"
  BG_RED = "\x1b[41m"
  RESET = "\x1b[0m"
