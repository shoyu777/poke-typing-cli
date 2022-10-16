import value_objects

type GameOption* = ref object
  numOfPokemon: NumOfPokemon
  lang: Language

func newGameOption*(num: int, sub: string): GameOption =
  let numOfPokemon = newNumOfPokemon(num)
  let lang = newLanguage(sub)
  return GameOption(numOfPokemon: numOfPokemon, lang: lang)

func numOfPokemon*(self: GameOption): NumOfPokemon =
  return self.numOfPokemon

func lang*(self: GameOption): Language =
  return self.lang