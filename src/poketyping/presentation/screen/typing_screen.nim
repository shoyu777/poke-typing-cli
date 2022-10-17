import ../widget/widget
import ../widget/pure_text_widget
import ../widget/column_widget
import ../widget/frame_top_widget
import ../widget/text_area_widget
import ../widget/border_widget
import ../widget/frame_bottom_widget
import ../../domain/game_state

type TypingScreen = ref object of Widget
  child: Widget
  gameState: GameState

func newTypingScreen*(gs: GameState): TypingScreen =
  return TypingScreen(
    child: newColumnWidget(
      children = @[
        new Widget,
        newPureTextWidget(text = "Type first character to Start!\n"),
        newPureTextWidget(text = "[CTRL-C] or [ESC] to exit.\n"),
        newFrameTopWidget(totalPokemon = 3, remainingPokemon = 2),
        newTextAreaWidget(text = "alksdjfalsdfa"),
        newBorderWidget(),
        newTextAreaWidget(text = "alksdjfalsdfa", row = 4),
        newBorderWidget(hidden = true),
        newTextAreaWidget(text = "alksdjfalsdfa", row = 4, hidden = true),
        newFrameBottomWidget(),
      ]
    ),
    gameState: gs
  )

method render*(self: TypingScreen) =
  self.child.render

proc update*(self: TypingScreen, gs: GameState) =
  self.gameState = gs
  self.render