import
  std/terminal,
  std/strutils,
  model/gamestatus,
  model/score,
  util/constants

const baseCursorPosX = 2
const baseCursorPosY = 9
const maxPartyCount = 6

proc pureText(s: string): string =
  return s.replace($COLORS.BG_GREEN, "").replace($COLORS.BG_RED, "").replace($COLORS.RESET, "")

proc screenReset() =
  stdout.eraseScreen()
  stdout.setCursorPos(0,0)

proc drawTopLine(gs: GameStatus) =
  stdout.write("Type first character to Start!\n")
  stdout.write("[CTRL-C] or [ESC] to exit.\n")
  stdout.write("╭" & "─".repeat(40) & "┨ ")
  # Defeated monster
  stdout.write("◓ ".repeat(gs.initialremainingPartyCount - gs.remainingPartyCount))
  # Remained monster
  stdout.setForeGroundColor(fgRed)
  stdout.write("◓ ".repeat(gs.remainingPartyCount))
  stdout.setForeGroundColor(fgDefault)
  # Up to max(usually 6)
  stdout.write("◌ ".repeat(maxPartyCount - gs.initialremainingPartyCount))
  stdout.write("┠───╮\n")

proc drawTextLine(gs: GameStatus, screenWidth: int = 60) =
  let fullSentense = gs.resultText & gs.currentText[gs.cursor .. ^1]
  let lines = fullSentense.split('*')
  for idx in 0 .. 2: # 3行固定
    if lines.len > idx:
      stdout.write("│ " & lines[idx] & " ".repeat(screenWidth - lines[idx].pureText.len - 3) & "│\n")
    else:
      stdout.write("│ " & " ".repeat(screenWidth - 3) & "│\n")

proc drawSeparator(screenWidth: int = 60) =
  stdout.write("├" & "─".repeat(screenWidth-2) & "┤\n")

proc drawHeadLine(str: string, screenWidth: int = 60) =
  stdout.write("│ " & str & " ".repeat(screenWidth - str.len - 3) & "│\n")

proc drawWroteText(gs: GameStatus, screenWidth: int = 60) =
  stdout.write("│ " & gs.wroteText.split('*')[^1] & " ".repeat(screenWidth - gs.wroteText.split('*')[^1].len - 3) & "│\n")

proc drawBottomLine(screenWidth: int = 60) =
  stdout.write("╰" & "─".repeat(screenWidth - 2) & "╯\n")

proc drawGameFlame*(gs: GameStatus, screenWidth: int = 60) =
  screenReset()
  drawTopLine(gs)
  drawHeadLine(gs.currentPokemonName)
  drawSeparator()
  drawTextLine(gs)
  drawSeparator()
  drawWroteText(gs)
  drawBottomLine()
  stdout.setCursorPos(baseCursorPosX + gs.wroteText.split('*')[^1].len, baseCursorPosY)

proc resultLeftCol(score: Score): array[7, string] =
  result[0] = "Defeated Pokemon:" & " ".repeat(10)
  for idx in 0 .. 5:
    if score.defeated.len > idx:
      result[idx + 1] = "  " & score.defeated[idx] & " ".repeat(25 - score.defeated[idx].len)
    else:
      result[idx + 1] = "  " & " ".repeat(25)

proc resultRightCol(score: Score): array[7, string] =
  result[0] = "│ Time             : " & $score.seconds & " sec" & " ".repeat(28 - 19 - len($score.seconds & " sec"))
  result[1] = "│ Total KeyPresses : " & $score.keypresses & " ".repeat(28 - 19 - len($score.keypresses))
  result[2] = "│ Corrects         : " & $score.corrects & " ".repeat(28 - 19 - len($score.corrects))
  result[3] = "│ Wrongs           : " & $score.wrongs & " ".repeat(28 - 19 - len($score.wrongs))
  result[4] = "│ WPM              : " & $score.wpm & " ".repeat(28 - 19 - len($score.wpm))
  result[5] = "│ Accuracy         : " & $score.accuracy & " %" & " ".repeat(28 - 19 - len($score.accuracy & " %"))
  result[6] = "│ " & " ".repeat(28)

proc drawResultLine(score: Score) =
  let leftCol = resultLeftCol(score)
  let rightCol = resultRightCol(score)
  for row in 0 .. 6:
    stdout.write("│ " & leftCol[row] & rightCol[row] & "│\n")

proc drawResultFlame*(gs: GameStatus, score: Score) =
  screenReset()
  drawTopLine(gs)
  drawHeadLine("YOU WIN!!")
  drawSeparator()
  drawResultLine(score)
  drawBottomLine()

proc cursorReset*() =
  screenReset()
  stdout.setCursorPos(0, 0)