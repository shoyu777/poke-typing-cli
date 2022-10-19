
import ../domain/[game_option, game_state, pokemon]
import ../di_container

type TypingUseCase* = ref object
  gameState*: GameState

proc newTypingUseCase*(gameOption: GameOption): TypingUseCase =
  new result
  let pokemons: seq[Pokemon] = di.pokemonRepository.getRamdomPokemons(gameOption)
  result.gameState = newGameState(party = pokemons)

proc typing*(self: TypingUseCase, key: string) =
  # ドメインロジックを記述する
  # GameStateの他にも中断処理、途中結果の保存などを入れられる
  self.gameState.updateGameState(key)
