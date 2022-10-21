import pokemon

type Score* = ref object
  corrects: Natural
  wrongs: Natural
  keypresses: Natural
  seconds: Natural
  defeatedPokemons: seq[Pokemon]

func newScore*(corrects: Natural, wrongs: Natural, keypresses: Natural, seconds: Natural, defeatedPokemons: seq[Pokemon]): Score =
  new result
  result.corrects = corrects
  result.wrongs = wrongs
  result.keypresses = keypresses
  result.seconds = seconds
  result.defeatedPokemons = defeatedPokemons

func corrects*(self: Score): Natural =
  return self.corrects

func wrongs*(self: Score): Natural =
  return self.wrongs

func keypresses*(self: Score): Natural =
  return self.keypresses

func seconds*(self: Score): Natural =
  return self.seconds

func defeatedPokemons*(self: Score): seq[Pokemon] =
  return self.defeatedPokemons

proc addDefeatedPokemon*(self: Score, pokemon: Pokemon) =
  self.defeatedPokemons.add(pokemon)

proc incCorrects*(self: Score) =
  self.corrects += 1
  self.keypresses += 1

proc decCorrects*(self: Score) =
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
