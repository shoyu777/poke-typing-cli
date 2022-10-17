import ../application/typing_usecase
import ../domain/game_state
import screen/typing_screen
import screen/result_screen
import std/terminal

# type
#   GameView* = ref object
#     viewModel*: GameViewModel

#   GameViewModel* = ref object
#     status*: string
#     useCase*: TypingUseCase
#     view*: GameView

type GameView* = ref object
  useCase: TypingUseCase

func newGameView*(useCase: TypingUseCase): GameView =
  return GameView(useCase: useCase)

proc render*(self: GameView, gameState: GameState) =
  var gs = gameState
  let typingScreen = newTypingScreen(gs)
  typingScreen.render

  var key: char
  while not gs.isAllDefeated:
    key = getch()
    gs = self.useCase.typing($key)
    typingScreen.update(gs)

  if gs.isAllDefeated:
    let resultScreen = newResultScreen(gs)
    resultScreen.render