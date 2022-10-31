import unittest
import poketyping/domain/pokemon

test "pokemon":
  let pikachu = newPokemon(
    id = 25,
    name = "pikachu",
    localName = "ピカチュウ",
    flavorText = "text",
    localFlavorText = "テキスト"
  )
  check pikachu.fullName == "No.0025 pikachu (ピカチュウ)"