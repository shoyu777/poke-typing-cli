type Pokemon* = ref object
  id: int
  name: string
  flavorText: string
  localFlavorText: string

proc newPokemon*(id: Natural, name: string, flavorText: string, localFlavorText: string): Pokemon =
  new result
  result.id = id
  result.name = name
  result.flavorText = flavorText
  result.localFlavorText = localFlavorText

func id*(self: Pokemon): int =
  return self.id

func name*(self: Pokemon): string =
  return self.name

func flavorText*(self: Pokemon): string =
  return self.flavorText

func localFlavorText*(self: Pokemon): string =
  return self.localFlavorText