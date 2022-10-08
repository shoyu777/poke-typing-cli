import std/terminal
import view
import gamestatus
import keycode


type Score* = ref object
  corrects: int
  wrongs: int
  keypresses: int

proc gameOver(score: Score, isCompleted: bool) =
  stdout.write("\n")

  # if isCompleted:
  #   outPutStats(gameStats)
  quit()

proc battleStart*() =
  var gs = newGameStatus()
  var score = new Score
  drawFlame(gs)

  var key: char
  while ($key != $KEYCODE.CTRL_C) and ($key != $KEYCODE.ESCAPE) and not gs.isCompleted:
    key = getch()
    case $key:
      of $KEYCODE.BACKSPACE:
        if gs.wroteText.len > 0:
          if gs.internalResult[^1] == 'T':
            score.corrects -= 1
          else:
            score.wrongs -= 1
          gs.wroteText = gs.wroteText[0 .. ^2]
          gs.resultText = gs.resultText[0 .. ^11]
          gs.internalResult = gs.internalResult[0 .. ^2]
          gs.cursor -= 1
          score.keypresses -= 1
      else:
        gs.wroteText.add(key)
        if key == gs.currentText[gs.cursor]:
          score.corrects += 1
          gs.resultText.add($KEYCODE.BG_GREEN)
          gs.internalResult.add("T")
        else:
          score.wrongs += 1
          gs.resultText.add($KEYCODE.BG_RED)
          gs.internalResult.add("F")
        gs.resultText.add(gs.currentText[gs.cursor] & $KEYCODE.RESET)
        score.keypresses += 1
        gs.cursor = gs.cursor + 1
    if gs.cursor == gs.currentText.len:
      gs.setNextPokemon()
    drawFlame(gs)

  gameOver(score, gs.isCompleted)