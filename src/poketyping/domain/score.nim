import pokemon

type Score* = ref object
  corrects: Natural
  wrongs: Natural
  keypresses: Natural
  seconds: Natural
  defeatedPokemons: seq[Pokemon]

proc corrects*(self: Score): Natural =
  return self.corrects

proc wrongs*(self: Score): Natural =
  return self.wrongs

proc keypresses*(self: Score): Natural =
  return self.keypresses

proc seconds*(self: Score): Natural =
  return self.seconds

proc defeatedPokemons*(self: Score): seq[Pokemon] =
  return self.defeatedPokemons

proc incCorrests*(self: Score) =
  self.corrects += 1
  self.keypresses += 1

proc decCorrests*(self: Score) =
  self.corrects -= 1
  self.keypresses -= 1

proc incWrongs*(self: Score) =
  self.wrongs += 1
  self.keypresses += 1

proc decWrongs*(self: Score) =
  self.wrongs -= 1
  self.keypresses -= 1

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
