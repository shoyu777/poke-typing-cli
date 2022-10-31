import 
  std/strutils,
  std/times,
  pokemon,
  score,
  key,
  play_status,
  ../util/utils

type GameState* = ref object
  wroteText: string
  judgeResults: string
  cursor: Natural
  remainingParty: seq[Pokemon]
  totalPokemon: Natural
  startedAt: DateTime
  status: PlayStatus
  score: Score

proc newGameState*(party: seq[Pokemon]): GameState =
  new result
  result.wroteText = ""
  result.judgeResults = ""
  result.cursor = 0
  result.remainingParty = party
  result.totalPokemon = party.len
  result.startedAt = now()
  result.score = new Score
  result.status = PlayStatus.notStarted

func wroteText*(self: GameState): string =
  return self.wroteText

func cursor*(self: GameState): Natural =
  return self.cursor

func totalPokemon*(self: GameState): Natural =
  return self.totalPokemon

func status*(self: GameState): PlayStatus =
  return self.status

func score*(self: GameState): Score =
  return self.score

func judgeResults*(self: GameState): string =
  return self.judgeResults

func isNotStarted*(self: GameState): bool =
  return self.status == PlayStatus.notStarted

func isCanceled*(self: GameState): bool =
  return self.status == PlayStatus.canceled

func isFinished*(self: GameState): bool =
  return self.status == PlayStatus.finished

proc currentText*(self: GameState): string =
  if self.remainingParty.present:
    return self.remainingParty.first.flavorText
  else:
    return ""

proc currentLocalText*(self: GameState): string =
  if self.remainingParty.present:
    return self.remainingParty.first.localFlavorText
  else:
    return ""

proc currentTextForJudge*(self: GameState): string =
  if self.remainingParty.present:
    return self.remainingParty.first.flavorText.replace("*", " ")
  else:
    return ""

proc currentPokemonName*(self: GameState): string =
  if self.remainingParty.present:
    return self.remainingParty.first.fullName

proc remainingsCount*(self: GameState): Natural =
  return self.remainingParty.len

proc elapsedSeconds*(self: GameState): int =
  if self.isNotStarted: return 0

  return (now() - self.startedAt).inSeconds.int

func noLocal*(self: GameState): bool =
  return self.currentLocalText == ""

proc setNextPokemon*(self: GameState) =
  self.remainingParty = self.remainingParty.drop()
  self.cursor = 0
  self.wroteText = ""
  self.judgeResults = ""
  if self.remainingParty.len == 0:
    self.status = PlayStatus.finished
    self.score.setSeconds(self.elapsedSeconds)

proc update*(self: GameState, key: Key) =
  if self.isFinished: return

  if self.isNotStarted:
    self.status = PlayStatus.playing
    self.startedAt = now()

  if key.isCancelKey():
    self.status = PlayStatus.canceled
    return
  elif key.isBackKey():
    if self.wroteText.len > 0:
      if self.judgeResults[^1] == 'T':
        self.score.decCorrects
      else:
        self.score.decWrongs
      self.wroteText = self.wroteText[0 .. ^2]
      self.judgeResults = self.judgeResults[0 .. ^2]
      self.cursor -= 1
    return
  elif key.isIgnoreKey():
    return
  else:
    # 正しいキーを入力したかのジャッジ
    if $key == $self.currentTextForJudge[self.cursor]:
      self.score.incCorrects
      self.judgeResults.add("T")
    else:
      self.score.incWrongs
      self.judgeResults.add("F")
    # 現在のカーソルが*だった場合には*を付与
    if self.currentText[self.cursor] == '*':
      self.wroteText.add("*")
    else:
      self.wroteText.add($key)
    self.cursor = self.cursor + 1

  if self.cursor == self.currentText.len:
    self.score.addDefeatedPokemon(self.remainingParty.first)
    self.setNextPokemon()
