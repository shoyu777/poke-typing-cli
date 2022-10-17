import std/strutils
import ../../util/constants

const DEFAULT_SCREEN_WIDTH* = 75

proc pureText*(s: string): string =
  return s.replace($COLORS.BG_GREEN, "").replace($COLORS.BG_RED, "").replace($COLORS.RESET, "")