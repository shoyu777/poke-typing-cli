import std/terminal
import view
import game_view_model

func newGameView*(vm: GameViewModel): GameView =
  new result
  result.viewModel = vm

proc renderResultScreen(self: GameView) =
  discard

proc renderTypingScreen(self: GameView) =
  discard

proc onChanged*(self: GameView) = 
  if self.viewModel.status == "completed":
    self.renderResultScreen()
    quit()
  elif self.viewModel.status == "canceled":
    quit()
  else:
    self.renderTypingScreen()
    let key = getch()
    self.viewModel.newKey(key = $key, view = self, callback = onChanged)

