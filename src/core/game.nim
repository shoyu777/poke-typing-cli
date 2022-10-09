import
  std/terminal,
  std/times,
  view,
  model/gamestatus,
  model/score,
  util/constants

proc gameOver(gs: GameStatus, score: Score) =
  if gs.isAllDefeated:
    score.seconds = gs.elapsedSeconds
    drawResultFlame(gs, score)
  quit()

proc battleStart*() =
  var gs = newGameStatus()
  var score = new Score
  drawGameFlame(gs)

  var key: char
  while not gs.isAllDefeated:
    key = getch()
    if not gs.isStarted:
      gs.isStarted = true
      gs.startedAt = now()
    case $key:
      of $KEYCODE.CTRL_C, $KEYCODE.ESCAPE:
        # exit game
        cursorReset()
        break
      of $KEYCODE.BACKSPACE:
        if gs.wroteText.len > 0:
          if gs.internalResult[^1] == 'T':
            score.corrects -= 1
          else:
            score.wrongs -= 1
          gs.wroteText = gs.wroteText[0 .. ^2]
          gs.internalResult = gs.internalResult[0 .. ^2]
          if gs.resultText[^1] == '*':
            gs.resultText = gs.resultText[0 .. ^12]
          else:
            gs.resultText = gs.resultText[0 .. ^11]
          gs.cursor -= 1
          score.keypresses -= 1
      else:
        if key == gs.currentTextForJudge[gs.cursor]:
          score.corrects += 1
          gs.resultText.add($COLORS.BG_GREEN)
          gs.internalResult.add("T")
        else:
          score.wrongs += 1
          gs.resultText.add($COLORS.BG_RED)
          gs.internalResult.add("F")
        if gs.currentText[gs.cursor] == '*':
          gs.resultText.add(" " & $COLORS.RESET & '*')
          gs.wroteText.add("*")
        else:
          gs.resultText.add(gs.currentText[gs.cursor] & $COLORS.RESET)
          gs.wroteText.add(key)
        score.keypresses += 1
        gs.cursor = gs.cursor + 1
    if gs.cursor == gs.currentText.len:
      score.defeated.add(gs.currentPokemonName)
      gs.setNextPokemon()
    drawGameFlame(gs)

  gameOver(gs, score)