import
  std/asyncdispatch,
  game_option,
  pokemon

type IPokemonRepository* = tuple
  getRamdomPokemons: proc(gameOption: GameOption): Future[seq[Pokemon]]