import
  ../widget/widget,
  ../widget/pure_text_widget,
  ../widget/column_widget,
  ../widget/frame_top_widget,
  ../widget/text_area_widget,
  ../widget/border_widget,
  ../widget/frame_bottom_widget,
  ../widget/cursor_widget,
  ../../domain/game_state,
  ../../util/constants,
  std/strutils,
  std/unicode

const baseCursorPosX = 2
const baseCursorPosY = 9

type TypingScreen = ref object of Widget
  gameState: GameState

func newTypingScreen*(gs: GameState): TypingScreen =
  return TypingScreen(gameState: gs)

func coloredText(text: string, judgeResults: string): string =
  for idx, judge in judgeResults:
    if judge == 'T':
      result.add($COLORS.BG_GREEN)
    else:
      result.add($COLORS.BG_RED)

    if text[idx] == '*':
      result.add(" " & $COLORS.RESET & '*')
    else:
      result.add(text[idx] & $COLORS.RESET)
  result.add(text[judgeResults.len .. ^1])

proc buildScreen(self: TypingScreen): Widget =
  let cursorOffset = if self.gameState.noLocal: 0 else: 4
  return newColumnWidget(
            children = @[
              new Widget, # sequenceがWidget型であることを認識させるためのおまじない。
              newPureTextWidget(text = "Type first character to Start! [CTRL-C] or [ESC] to exit."),
              newFrameTopWidget(totalPokemon = self.gameState.totalPokemon, remainingPokemon = self.gameState.remainingsCount),
              newTextAreaWidget(text = self.gameState.currentPokemonName),
              newBorderWidget(),
              newTextAreaWidget(text = coloredText(self.gameState.currentText, self.gameState.judgeResults), row = 4),
              newBorderWidget(hidden = self.gameState.noLocal),
              newTextAreaWidget(text = self.gameState.currentLocalText, row = 3, hidden = self.gameState.noLocal),
              newBorderWidget(),
              newTextAreaWidget(text = self.gameState.wroteText.split('*')[^1]),
              newFrameBottomWidget(),
              newCursorWidget(posX = baseCursorPosX + self.gameState.wroteText.split('*')[^1].runeLen, posY = baseCursorPosY + cursorOffset )
            ]
          )

method render*(self: TypingScreen) =
  self.screenReset()
  self.buildScreen.render

proc update*(self: TypingScreen, gs: GameState) =
  self.gameState = gs
  self.screenReset()
  self.render