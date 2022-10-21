import
  std/nre,
  std/options,
  ../util/constants

type Key* = ref object
  value: string

func newKey*(key: string): Key =
  return Key(value: key)

func isIgnoreKey*(self: Key): bool =
  # *は除外した半角英数記号以外
  return self.value.match(re"^[a-zA-Z0-9 -)+-/:-@¥[-`{-~]*$").isNone

func isCancelKey*(self: Key): bool =
  return self.value == $KEYCODE.CTRL_C or self.value == $KEYCODE.ESCAPE

func isBackKey*(self: Key): bool =
  return self.value == $KEYCODE.BACKSPACE

func `$`*(self: Key): string =
  return self.value