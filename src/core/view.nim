import
  std/terminal,
  std/unicode,
  std/strutils,
  model/gamestatus,
  model/score,
  util/constants,
  util/wcwidth

const baseCursorPosX = 2
const baseCursorPosY = 10
const maxPartyCount = 6
const defaultScreenWidth = 75

proc pureText(s: string): string =
  return s.replace($COLORS.BG_GREEN, "").replace($COLORS.BG_RED, "").replace($COLORS.RESET, "")

proc screenReset() =
  stdout.eraseScreen()
  stdout.setCursorPos(0,0)

proc drawSeparator(screenWidth: int = defaultScreenWidth) =
  stdout.write("├" & "─".repeat(screenWidth-2) & "┤\n")

proc drawTopLine(gs: GameStatus, screenWidth: int = defaultScreenWidth) =
  stdout.write("Type first character to Start!\n")
  stdout.write("[CTRL-C] or [ESC] to exit.\n")
  stdout.write("╭" & "─".repeat(screenWidth - 20) & "┨ ")
  # Defeated monster
  stdout.write("◓ ".repeat(gs.initialremainingPartyCount - gs.remainingPartyCount))
  # Remained monster
  stdout.setForeGroundColor(fgRed)
  stdout.write("◓ ".repeat(gs.remainingPartyCount))
  stdout.setForeGroundColor(fgDefault)
  # Up to max(usually 6)
  stdout.write("◌ ".repeat(maxPartyCount - gs.initialremainingPartyCount))
  stdout.write("┠───╮\n")

proc drawTextLine(gs: GameStatus, screenWidth: int = defaultScreenWidth) =
  let fullSentense = gs.resultText & gs.currentText[gs.cursor .. ^1]
  let lines = fullSentense.split('*')
  for idx in 0 .. 3: # 4行固定
    if lines.len > idx:
      stdout.write("│ " & lines[idx] & " ".repeat(screenWidth - lines[idx].pureText.runeLen - 3) & "│\n")
    else:
      stdout.write("│ " & " ".repeat(screenWidth - 3) & "│\n")
  drawSeparator()

proc drawLocalTextLine(gs: GameStatus, screenWidth: int = defaultScreenWidth) =
  if gs.currentLocalText == "": return

  let lines = gs.currentLocalText.split('*')
  for idx in 0 .. 2: # 3行固定
    if lines.len > idx:
      stdout.write("│ " & lines[idx] & " ".repeat(screenWidth - lines[idx].wcswidthCjk - 3) & "│\n")
    else:
      stdout.write("│ " & " ".repeat(screenWidth - 3) & "│\n")
  drawSeparator()

proc drawHeadLine(str: string, screenWidth: int = defaultScreenWidth) =
  stdout.write("│ " & str & " ".repeat(screenWidth - str.runeLen - 3) & "│\n")
  drawSeparator()

proc drawWroteText(gs: GameStatus, screenWidth: int = defaultScreenWidth) =
  stdout.write("│ " & gs.wroteText.split('*')[^1] & " ".repeat(screenWidth - gs.wroteText.split('*')[^1].runeLen - 3) & "│\n")

proc drawBottomLine(screenWidth: int = defaultScreenWidth) =
  stdout.write("╰" & "─".repeat(screenWidth - 2) & "╯\n")

proc drawGameFlame*(gs: GameStatus, screenWidth: int = defaultScreenWidth) =
  screenReset()
  drawTopLine(gs)
  drawHeadLine(gs.currentPokemonName)
  drawTextLine(gs)
  drawLocalTextLine(gs)
  drawWroteText(gs)
  drawBottomLine()
  let offset = 
    if gs.currentLocalText == "":
      0
    else:
      4
  stdout.setCursorPos(baseCursorPosX + gs.wroteText.split('*')[^1].runeLen, baseCursorPosY + offset)

proc resultLeftCol(score: Score): array[7, string] =
  result[0] = "Defeated Pokemon:" & " ".repeat(15)
  for idx in 0 .. 5:
    if score.defeated.len > idx:
      result[idx + 1] = "  " & score.defeated[idx] & " ".repeat(30 - score.defeated[idx].runeLen)
    else:
      result[idx + 1] = "  " & " ".repeat(30)

proc resultRightCol(score: Score): array[7, string] =
  result[0] = "│ Time             : " & $score.seconds & " sec" & " ".repeat(38 - 19 - runeLen($score.seconds & " sec"))
  result[1] = "│ Total KeyPresses : " & $score.keypresses & " ".repeat(38 - 19 - runeLen($score.keypresses))
  result[2] = "│ Corrects         : " & $score.corrects & " ".repeat(38 - 19 - runeLen($score.corrects))
  result[3] = "│ Wrongs           : " & $score.wrongs & " ".repeat(38 - 19 - runeLen($score.wrongs))
  result[4] = "│ WPM              : " & $score.wpm & " ".repeat(38 - 19 - runeLen($score.wpm))
  result[5] = "│ Accuracy         : " & $score.accuracy & " %" & " ".repeat(38 - 19 - runeLen($score.accuracy & " %"))
  result[6] = "│ " & " ".repeat(38)

proc drawResultLine(score: Score) =
  let leftCol = resultLeftCol(score)
  let rightCol = resultRightCol(score)
  for row in 0 .. 6:
    stdout.write("│ " & leftCol[row] & rightCol[row] & "│\n")

proc drawResultFlame*(gs: GameStatus, score: Score) =
  screenReset()
  drawTopLine(gs)
  drawHeadLine("YOU WIN!!")
  drawResultLine(score)
  drawBottomLine()

proc cursorReset*() =
  screenReset()
  stdout.setCursorPos(0, 0)