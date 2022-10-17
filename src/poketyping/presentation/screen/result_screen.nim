import ../widget/widget
import ../widget/pure_text_widget
import ../widget/column_widget
import ../widget/frame_top_widget
import ../widget/text_area_widget
import ../widget/border_widget
import ../widget/frame_bottom_widget
import ../widget/score_widget
import ../../domain/score
import ../../domain/game_state


type ResultScreen = ref object of Widget
  child: Widget
  gameState: GameState

func newResultScreen*(gs: GameState): ResultScreen =
  let score = new Score
  return ResultScreen(
    child: newColumnWidget(
      children = @[
        new Widget,
        newPureTextWidget(text = "Type first character to Start!\n"),
        newPureTextWidget(text = "[CTRL-C] or [ESC] to exit.\n"),
        newFrameTopWidget(totalPokemon = 3, remainingPokemon = 2),
        newTextAreaWidget(text = "alksdjfalsdfa"),
        newBorderWidget(),
        newScoreWidget(score = score),
        newFrameBottomWidget(),
      ]
    ),
    gameState: gs
  )

method render*(self: ResultScreen) =
  self.child.render

proc update*(self: ResultScreen, gs: GameState) =
  self.gameState = gs
  self.render