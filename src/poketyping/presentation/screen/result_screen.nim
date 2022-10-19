import
  ../widget/widget,
  ../widget/pure_text_widget,
  ../widget/column_widget,
  ../widget/frame_top_widget,
  ../widget/text_area_widget,
  ../widget/border_widget,
  ../widget/frame_bottom_widget,
  ../widget/score_widget,
  ../../domain/game_state

type ResultScreen = ref object of Widget
  gameState: GameState

func newResultScreen*(gs: GameState): ResultScreen =
  return ResultScreen(gameState: gs)

proc buildScreen(self: ResultScreen): Widget =
  return newColumnWidget(
            children = @[
              new Widget,
              newPureTextWidget(text = "[CTRL-C] or [ESC] to exit."),
              newFrameTopWidget(totalPokemon = self.gameState.initialRemainingPartyCount, remainingPokemon = self.gameState.remainingParty.len),
              newTextAreaWidget(text = "YOU WIN!!"),
              newBorderWidget(),
              newScoreWidget(score = self.gameState.score),
              newFrameBottomWidget(),
            ]
          )

method render*(self: ResultScreen) =
  self.screenReset()
  self.buildScreen.render
