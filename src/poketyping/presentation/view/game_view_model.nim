import view
import ../../application/typing_usecase
import ../../domain/game_state

proc newGameViewModel*(uc: TypingUseCase): GameViewModel =
  new result
  result.status = "playing"
  result.useCase = uc

func status*(self: GameViewModel): string =
  return self.status


# Viewにcallbackするための型
type Callback = proc (view: GameView) {.closure.}

proc newKey*(self: GameViewModel, key: string, view: GameView, callback: Callback) =
  let updatedGameState: GameState = self.useCase.typing(key)
  # do something
  view.callback()