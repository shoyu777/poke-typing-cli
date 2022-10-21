type GameOption* = ref object
  numOfPokemon: Natural
  lang: string

func newGameOption*(num: int, lang: string): GameOption =
  return GameOption(numOfPokemon: num, lang: lang)

func numOfPokemon*(self: GameOption): Natural =
  return self.numOfPokemon

func lang*(self: GameOption): string =
  return self.lang