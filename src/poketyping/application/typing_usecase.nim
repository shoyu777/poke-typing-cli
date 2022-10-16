
import ../domain/[game_option, game_state, pokemon]

type TypingUseCase* = ref object
  gameState: GameState

proc newTypingUseCase*(gameOption: GameOption): TypingUseCase =
  new result
  # TODO: ポケモンを取得する
  # TODO: GameStateを初期化する
  let pokemons: seq[Pokemon] = @[]
  let gs = newGameState(party = pokemons)

  result.gameState = gs

proc typing*(self: TypingUseCase, key: string): GameState =
  # ドメインロジックを記述する
  # GameStateの他にも中断処理、途中結果の保存などを入れられる
  # TODO: GameStateの更新処理
  result = self.gameState