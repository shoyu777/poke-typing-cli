import 
  std/strutils,
  std/times,
  pokemon,
  score,
  ../util/utils

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

proc currentText*(self: GameState): string =
  if self.remainingParty.members.present:
    return self.remainingParty.members.first.flavorText
  else:
    return ""

proc currentLocalText*(self: GameState): string =
  if self.remainingParty.members.present:
    return self.remainingParty.members.first.localFlavorText
  else:
    return ""

proc currentTextForJudge*(self: GameState): string =
  if self.remainingParty.members.present:
    return self.remainingParty.members.first.flavorText.replace("*", " ")
  else:
    return ""

proc currentPokemonName*(self: GameState): string =
  if self.remainingParty.members.present:
    let no = "No." & align($self.remainingParty.members.first.id, 4, '0') & " "
    let name = self.remainingParty.members.first.name
    var localName = if self.remainingParty.members.first.localName != "":
        " (" & self.remainingParty.members.first.localName & ")"
      else:
        ""
    return no & name & localName

proc setNextPokemon*(self: GameState) =
  self.remainingParty.members = self.remainingParty.members.drop()
  self.cursor = 0
  self.resultText = ""
  self.wroteText = ""
  self.internalResult = ""

proc remainingPartyCount*(self: GameState): Natural =
  return self.remainingParty.members.len

func isAllDefeated*(self: GameState): bool =
  return self.remainingPartyCount == 0

proc elapsedSeconds*(self: GameState): int =
  if self.isStarted:
    return (now() - self.startedAt).inSeconds.int
  else:
    return 0

proc isInvalidKey(key: string): bool =
  return false # TODO: impl

proc updateGameState*(self: GameState, key: string) =
  if isInvalidKey(key): return

