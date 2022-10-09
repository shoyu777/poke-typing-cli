import
  std/strutils,
  std/times,
  party,
  pokemon,
  ../util/utils

type GameStatus* = ref object
  isCompleted*: bool
  wroteText*: string
  resultText*: string
  internalResult*: string
  cursor*: Natural
  remainingParty*: Party
  initialremainingPartyCount*: Natural
  isStarted*: bool
  startedAt*: DateTime

proc newGameStatus*(n: int = 6, sub: string = ""): GameStatus =
  new result
  result.isCompleted = false
  result.wroteText = ""
  result.resultText = ""
  result.internalResult = ""
  result.cursor = 0
  result.remainingParty = newParty(n = n, sub = sub)
  result.initialremainingPartyCount = result.remainingParty.count
  result.isStarted = false
  result.startedAt = now()

proc currentText*(self: GameStatus): string =
  if self.remainingParty.members.present:
    return self.remainingParty.members.first.flavorText()
  else:
    return ""

proc currentTextForJudge*(self: GameStatus): string =
  if self.remainingParty.members.present:
    return self.remainingParty.members.first.flavorText.replace("*", " ")
  else:
    return ""

proc currentPokemonName*(self: GameStatus): string =
  if self.remainingParty.members.present:
    return "No." & $self.remainingParty.members.first.id & " " & self.remainingParty.members.first.name

proc setNextPokemon*(self: GameStatus) =
  self.remainingParty.members = self.remainingParty.members.drop()
  self.cursor = 0
  self.resultText = ""
  self.wroteText = ""
  self.internalResult = ""

proc remainingPartyCount*(self: GameStatus): Natural =
  return self.remainingParty.members.len

func isAllDefeated*(self: GameStatus): bool =
  return self.remainingPartyCount == 0

proc elapsedSeconds*(self: GameStatus): int =
  if self.isStarted:
    return (now() - self.startedAt).inSeconds.int
  else:
    return 0