type GameOption* = ref object
  numOfPokemon: Natural
  lang: string

func newGameOption*(num: int, sub: string): GameOption =
  return GameOption(numOfPokemon: num, lang: sub)

func numOfPokemon*(self: GameOption): Natural =
  return self.numOfPokemon

func lang*(self: GameOption): string =
  return self.lang