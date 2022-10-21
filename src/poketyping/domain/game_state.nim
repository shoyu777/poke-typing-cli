import 
  std/strutils,
  std/times,
  std/options,
  std/nre,
  pokemon,
  score,
  play_status,
  ../util/utils,
  ../util/constants

type GameState* = ref object
  wroteText*: string
  resultText*: string
  internalResult*: string
  cursor*: Natural
  remainingParty*: seq[Pokemon]
  totalPokemon*: Natural
  startedAt*: DateTime
  status*: PlayStatus
  score*: Score

proc newGameState*(party: seq[Pokemon]): GameState =
  new result
  result.wroteText = ""
  result.resultText = ""
  result.internalResult = ""
  result.cursor = 0
  result.remainingParty = party
  result.totalPokemon = party.len
  result.startedAt = now()
  result.score = new Score
  result.status = PlayStatus.notStarted

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

proc setNextPokemon*(self: GameState) =
  self.remainingParty = self.remainingParty.drop()
  self.cursor = 0
  self.resultText = ""
  self.wroteText = ""
  self.internalResult = ""
  if self.remainingParty.len == 0: self.status = PlayStatus.finished

proc remainingsCount*(self: GameState): Natural =
  return self.remainingParty.len

proc elapsedSeconds*(self: GameState): int =
  if self.isNotStarted: return 0

  return (now() - self.startedAt).inSeconds.int

func noLocal*(self: GameState): bool =
  return self.currentLocalText == ""

func isIgnoreKey(key: string): bool =
  # *は除外した半角英数記号以外
  return key.match(re"^[a-zA-Z0-9 -)+-/:-@¥[-`{-~]*$").isNone

func isCancelKey(key: string): bool =
  return key == $KEYCODE.CTRL_C or key == $KEYCODE.ESCAPE

func isBackKey(key: string): bool =
  return key == $KEYCODE.BACKSPACE

proc updateGameState*(self: GameState, key: string) =
  if self.isNotStarted:
    self.status = PlayStatus.playing
    self.startedAt = now()

  if isCancelKey(key):
    self.status = PlayStatus.canceled
    return
  elif isBackKey(key):
    if self.wroteText.len > 0:
      if self.internalResult[^1] == 'T':
        self.score.decCorrects
      else:
        self.score.decWrongs
      self.wroteText = self.wroteText[0 .. ^2]
      self.internalResult = self.internalResult[0 .. ^2]
      if self.resultText[^1] == '*':
        self.resultText = self.resultText[0 .. ^12]
      else:
        self.resultText = self.resultText[0 .. ^11]
      self.cursor -= 1
    return
  elif isIgnoreKey(key):
    return
  else:
    # 正しいキーを入力したかのジャッジ
    if key == $self.currentTextForJudge[self.cursor]:
      self.score.incCorrects
      self.resultText.add($COLORS.BG_GREEN)
      self.internalResult.add("T")
    else:
      self.score.incWrongs
      self.resultText.add($COLORS.BG_RED)
      self.internalResult.add("F")
    # 現在のカーソルが*だった場合には*を付与
    if self.currentText[self.cursor] == '*':
      self.resultText.add(" " & $COLORS.RESET & '*')
      self.wroteText.add("*")
    else:
      self.resultText.add(self.currentText[self.cursor] & $COLORS.RESET)
      self.wroteText.add(key)
    self.cursor = self.cursor + 1

  if self.cursor == self.currentText.len:
    self.score.addDefeatedPokemon(self.remainingParty.first)
    self.setNextPokemon()
