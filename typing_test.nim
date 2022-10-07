import std/terminal
import std/strutils

type GameStats = ref object
  corrects: int
  wrongs: int
  keypresses: int
  wpm: int
  accuracy: int

type KEYCODE {.pure.} = enum
  CTRL_C = "\u0003"
  ESCAPE = "\u001B"
  BACKSPACE = "\u007f"
  FG_GREEN = "\x1b[32m"
  BG_RED = "\x1b[41m"
  RESET = "\x1b[0m"

const pokemonName = "No.25 Pikachu"
const text = "This pikapika pikachu. Yes."
var wrote: string = ""
var cursor: int = 0
var resultText: string = ""
var internalResult: string = ""
var isCompleted: bool = false

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
  stdout.write("┠───╮" & "\n")

proc drawTextLine(screenWidth: int = 60) =
  stdout.write("│ " & resultText & text[cursor .. ^1] & " ".repeat(screenWidth - text.len - 3) & "│\n")

proc drawSeparator(screenWidth: int = 60) =
  stdout.write("├" & "─".repeat(screenWidth-2) & "┤\n")

proc drawNameLine(screenWidth: int = 60) =
  stdout.write("│ " & pokemonName & " ".repeat(screenWidth - pokemonName.len - 3) & "│\n")

proc drawFlame(wrote: string, screenWidth: int = 60) =
  screenReset()
  drawTopLine()
  drawNameLine()
  drawSeparator()
  drawTextLine()
  drawTextLine()
  drawTextLine()
  drawSeparator()
  stdout.write("│ " & wrote & " ".repeat(screenWidth - wrote.len - 3) & "│\n")
  
proc outPutStats(gameStats: GameStats) =
  stdout.write("Total KeyPress: " & $gameStats.keypresses & "\n")
  stdout.write("Corrects: " & $gameStats.corrects & "\n")
  stdout.write("Wrongs: " & $gameStats.wrongs & "\n")

proc init() =
  drawFlame(wrote)

proc gameOver(gameStats: GameStats, isCompleted: bool) =
  stdout.write("\n")

  if isCompleted:
    outPutStats(gameStats)
  quit()

# main process
init()
var gameStats = new GameStats

var key: char
while ($key != $KEYCODE.CTRL_C) and ($key != $KEYCODE.ESCAPE) and not isCompleted:
  key = getch()
  case $key:
    of $KEYCODE.BACKSPACE:
      if wrote.len > 0:
        if internalResult[^1] == 'T':
          gameStats.corrects -= 1
        else:
          gameStats.wrongs -= 1
        wrote = wrote[0 .. ^2]
        resultText = resultText[0 .. ^11]
        internalResult = internalResult[0 .. ^2]
        cursor -= 1
        gameStats.keypresses -= 1
    else:
      wrote.add(key)
      if key == text[cursor]:
        gameStats.corrects += 1
        resultText.add($KEYCODE.FG_GREEN)
        internalResult.add("T")
      else:
        gameStats.wrongs += 1
        resultText.add($KEYCODE.BG_RED)
        internalResult.add("F")
      resultText.add(text[cursor] & $KEYCODE.RESET)
      gameStats.keypresses += 1
      cursor = cursor + 1
  if cursor == text.len:
    isCompleted = true
  drawFlame(wrote)

gameOver(gameStats, isCompleted)
