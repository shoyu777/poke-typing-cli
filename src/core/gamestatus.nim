import party
import utils

type GameStatus* = ref object
  isCompleted*: bool
  wroteText*: string
  resultText*: string
  internalResult*: string
  cursor*: int
  party*: Party

proc newGameStatus*(): GameStatus =
  new result
  result.isCompleted = false
  result.wroteText = ""
  result.resultText = ""
  result.internalResult = ""
  result.cursor = 0
  result.party = newParty()

proc currentText*(self: GameStatus): string =
  if self.party.members.present:
    return self.party.members.first.flavorText
  else:
    return ""

proc currentPokeName*(self: GameStatus): string =
  if self.party.members.present:
    return "No." & $self.party.members.first.id & " " & self.party.members.first.name

proc setNextPokemon*(self: GameStatus) =
  self.party.members = self.party.members.drop()
  self.cursor = 0
  self.resultText = ""
  self.wroteText = ""
  self.internalResult = ""
  if self.party.members.len == 0:
    self.isCompleted = true