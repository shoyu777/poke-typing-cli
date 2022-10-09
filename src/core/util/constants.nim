type KEYCODE* {.pure.} = enum
  CTRL_C = "\u0003"
  ESCAPE = "\u001B"
  BACKSPACE = "\u007f"

type COLORS* {.pure.} = enum
  BG_GREEN = "\x1b[42m"
  BG_RED = "\x1b[41m"
  RESET = "\x1b[0m"

type ERROR_MSGS* {.pure.} = enum
  ARG_ERR = "\n== Argument Error ==\n"
  NUM_ERR = "Num of Pokemon must be between 1 and 6."