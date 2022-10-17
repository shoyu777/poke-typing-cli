import 
  std/strutils,
  std/times,
  pokemon,
  score,
  ../util/utils,
  ../util/constants

type GameState* = ref object
  wroteText*: string
  resultText*: string
  internalResult*: string
  cursor*: Natural
  remainingParty*: seq[Pokemon]
  initialRemainingPartyCount*: Natural
  isStarted*: bool
  startedAt*: DateTime
  score*: Score
  isCanceled*: bool

proc newGameState*(party: seq[Pokemon]): GameState =
  new result
  result.wroteText = ""
  result.resultText = ""
  result.internalResult = ""
  result.cursor = 0
  result.remainingParty = party
  result.initialRemainingPartyCount = party.len
  result.isStarted = false
  result.startedAt = now()
  result.score = new Score
  result.isCanceled = false

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

proc remainingPartyCount*(self: GameState): Natural =
  return self.remainingParty.len

func isAllDefeated*(self: GameState): bool =
  return self.remainingPartyCount == 0

proc elapsedSeconds*(self: GameState): int =
  if self.isStarted:
    return (now() - self.startedAt).inSeconds.int
  else:
    return 0

proc isIgnoreKey(key: string): bool =
  return false # TODO: impl

proc updateGameState*(self: GameState, key: string) =
  if isIgnoreKey(key): return

  if not self.isStarted:
    self.isStarted = true
    self.startedAt = now()

  case key:
  of $KEYCODE.CTRL_C, $KEYCODE.ESCAPE:
    self.isCanceled = true
    return
  of $KEYCODE.BACKSPACE:
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
  else:
    if key == $self.currentTextForJudge[self.cursor]:
      self.score.incCorrects
      self.resultText.add($COLORS.BG_GREEN)
      self.internalResult.add("T")
    else:
      self.score.incWrongs
      self.resultText.add($COLORS.BG_RED)
      self.internalResult.add("F")
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
