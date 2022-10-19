import
  game_option,
  pokemon

type IPokemonRepository* = tuple
  getRamdomPokemons: proc(gameOption: GameOption): seq[Pokemon]