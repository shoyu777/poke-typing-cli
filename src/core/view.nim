import std/terminal
import std/strutils
import gamestatus
import keycode

proc screenReset() =
  stdout.eraseScreen()
  stdout.setCursorPos(0,0)

proc drawTopLine() =
  stdout.write("Type first character to Start!\n")
  stdout.write("[CTRL-C] or [ESC] to exit.\n")
  stdout.write("╭" & "─".repeat(40) & "┨ ")
  stdout.setForeGroundColor(fgRed)
  stdout.write("◓ ".repeat(6))
  stdout.setForeGroundColor(fgDefault)
  stdout.write("┠───╮\n")

proc drawTextLine(gs: GameStatus, screenWidth: int = 60) =
  let fullSentense = gs.resultText & gs.currentText[gs.cursor .. ^1]
  let lines = fullSentense.split('*')
  let baseLines = gs.currentText.split('*')
  for idx in 0 .. 2: # 3行固定
    if lines.len > idx:
      stdout.write("│ " & lines[idx] & " ".repeat(screenWidth - baseLines[idx].len - 3) & "│\n")
    else:
      stdout.write("│ " & " ".repeat(screenWidth - 3) & "│\n")

proc drawSeparator(screenWidth: int = 60) =
  stdout.write("├" & "─".repeat(screenWidth-2) & "┤\n")

proc drawNameLine(gs: GameStatus, screenWidth: int = 60) =
  stdout.write("│ " & gs.currentPokeName & " ".repeat(screenWidth - gs.currentPokeName.len - 3) & "│\n")

proc drawLastLine(screenWidth: int = 60) =
  stdout.write("╰" & "─".repeat(screenWidth - 2) & "╯\n")

proc drawFlame*(gs: GameStatus, screenWidth: int = 60) =
  screenReset()
  drawTopLine()
  drawNameLine(gs)
  drawSeparator()
  drawTextLine(gs)
  drawSeparator()
  drawLastLine()
  stdout.write("│ ")
  #stdout.write("│ " & gs.wroteText & " ".repeat(screenWidth - gs.wroteText.len - 3) & "│\n")
  
# proc outPutStats(score: Score) =
#   stdout.write("Total KeyPress: " & $score.keypresses & "\n")
#   stdout.write("Corrects: " & $score.corrects & "\n")
#   stdout.write("Wrongs: " & $score.wrongs & "\n")
