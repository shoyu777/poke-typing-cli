import
  ../../domain/score,
  ../../domain/pokemon,
  widget,
  std/strutils,
  wcwidth,
  widget_util

const defaultLeftColWidth = 40

type ScoreWidget* = ref object of Widget
  score: Score

func newScoreWidget*(score: Score): ScoreWidget =
  return ScoreWidget(score: score)

func scoreLeftCol(self: ScoreWidget): array[7, string] =
  result[0] = "Defeated Pokemon:" & " ".repeat(defaultLeftColWidth - 15)
  for idx in 0 .. 5:
    if self.score.defeatedPokemons.len > idx:
      result[idx + 1] = "  " & self.score.defeatedPokemons[idx].fullName & " ".repeat(defaultLeftColWidth - self.score.defeatedPokemons[idx].fullName.wcswidth)
    else:
      result[idx + 1] = "  " & " ".repeat(defaultLeftColWidth)

func scoreRightCol(self: ScoreWidget): array[7, string] =
  let rightColWidth = DEFAULT_SCREEN_WIDTH - defaultLeftColWidth - 5
  let labelWidth = "│------------------: ".wcswidth
  result[0] = "│ Time             : " & $self.score.seconds & " sec" & " ".repeat(rightColWidth - labelWidth - wcswidth($self.score.seconds & " sec"))
  result[1] = "│ Total KeyPresses : " & $self.score.keypresses & " ".repeat(rightColWidth - labelWidth - wcswidth($self.score.keypresses))
  result[2] = "│ Corrects         : " & $self.score.corrects & " ".repeat(rightColWidth - labelWidth - wcswidth($self.score.corrects))
  result[3] = "│ Wrongs           : " & $self.score.wrongs & " ".repeat(rightColWidth - labelWidth - wcswidth($self.score.wrongs))
  result[4] = "│ WPM              : " & $self.score.wpm & " ".repeat(rightColWidth - labelWidth - wcswidth($self.score.wpm))
  result[5] = "│ Accuracy         : " & $self.score.accuracy & " %" & " ".repeat(rightColWidth - labelWidth - wcswidth($self.score.accuracy & " %"))
  result[6] = "│ " & " ".repeat(rightColWidth - 2)

method render*(self: ScoreWidget) =
  let leftCol = self.scoreLeftCol
  let rightCol = self.scoreRightCol
  for row in 0 .. 6:
    stdout.write("│ " & leftCol[row] & rightCol[row] & "│\n")