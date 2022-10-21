import unittest
import
  poketyping/domain/pokemon,
  poketyping/domain/game_state,
  poketyping/domain/score

suite "gamestate":
  setup:
    let party: seq[Pokemon] = @[
      newPokemon(
        id = 25,
        name = "pikachu",
        localName = "ピカチュウ",
        flavorText = "first text",
        localFlavorText = "テキスト"
      ),
      newPokemon(
        id = 133,
        name = "eevee",
        localName = "イーブイ",
        flavorText = "second text",
        localFlavorText = "テキストテキスト"
      ),
    ]
    let gameState = newGameState(party)

  test "currentText":
    check gameState.currentText == "first text"
    gameState.setNextPokemon
    check gameState.currentText == "second text"
    gameState.setNextPokemon
    check gameState.currentText == ""

  test "remainingPartyCount":
    check gameState.remainingPartyCount == 2
    gameState.setNextPokemon
    check gameState.remainingPartyCount == 1
    gameState.setNextPokemon
    check gameState.remainingPartyCount == 0

  test "currentPokemonName":
    check gameState.currentPokemonName == "No.0025 pikachu (ピカチュウ)"
    gameState.setNextPokemon
    check gameState.currentPokemonName == "No.0133 eevee (イーブイ)"
    gameState.setNextPokemon
    check gameState.currentPokemonName == ""
  
  test "isAllDefeated":
    check gameState.isAllDefeated == false
    gameState.setNextPokemon
    check gameState.isAllDefeated == false
    gameState.setNextPokemon
    check gameState.isAllDefeated == true
