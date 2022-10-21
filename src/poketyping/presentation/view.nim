import ../application/typing_usecase
import ../domain/game_state
import widget/widget
import screen/typing_screen
import screen/result_screen
import std/terminal

type GameView* = ref object
  useCase: TypingUseCase

func newGameView*(useCase: TypingUseCase): GameView =
  return GameView(useCase: useCase)

proc render*(self: GameView) =
  let typingScreen = newTypingScreen(self.useCase.gameState)
  typingScreen.render

  var key: char
  while not self.useCase.gameState.isAllDefeated and not self.useCase.gameState.isCanceled:
    key = getch()
    self.useCase.typing($key)
    typingScreen.update(self.useCase.gameState)

  if self.useCase.gameState.isAllDefeated:
    let resultScreen = newResultScreen(self.useCase.gameState)
    resultScreen.render
  else:
    # Game Canceled.
    typingScreen.screenReset()
