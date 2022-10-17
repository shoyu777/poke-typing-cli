import std/strutils

type Pokemon* = ref object
  id: int
  name: string
  localName: string
  flavorText: string
  localFlavorText: string

proc newPokemon*(id: Natural, name: string, localName: string, flavorText: string, localFlavorText: string): Pokemon =
  new result
  result.id = id
  result.name = name
  result.localName = localName
  result.flavorText = flavorText
  result.localFlavorText = localFlavorText

func id*(self: Pokemon): int =
  return self.id

func name*(self: Pokemon): string =
  return self.name

func localName*(self: Pokemon): string =
  return self.localName

func flavorText*(self: Pokemon): string =
  return self.flavorText

func localFlavorText*(self: Pokemon): string =
  return self.localFlavorText

func fullName*(self: Pokemon): string =
  let no = "No." & align($self.id, 4, '0') & " "
  var localName = if self.localName != "":
      " (" & self.localName & ")"
    else:
      ""
  result = no & self.name & localName