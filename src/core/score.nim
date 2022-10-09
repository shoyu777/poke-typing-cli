type Score* = ref object
  corrects*: Natural
  wrongs*: Natural
  keypresses*: Natural
  seconds*: Natural
  defeated*: seq[string]

func accuracy*(self: Score): int =
  if self.keypresses > 0:
    return (self.corrects.toFloat / self.keypresses.toFloat * 100.0).toInt
  else:
    return 0

func wpm*(self: Score): int =
  if self.seconds > 0:
    return (self.keypresses.toFloat / self.seconds.toFloat * 60).toInt
  else:
    return 0
