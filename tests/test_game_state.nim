import unittest
import
  poketyping/domain/pokemon,
  poketyping/domain/game_state,
  poketyping/domain/key,
  poketyping/domain/score,
  poketyping/domain/play_status

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

  test "remainingsCount":
    check gameState.remainingsCount == 2
    gameState.setNextPokemon
    check gameState.remainingsCount == 1
    gameState.setNextPokemon
    check gameState.remainingsCount == 0

  test "currentPokemonName":
    check gameState.currentPokemonName == "No.0025 pikachu (ピカチュウ)"
    gameState.setNextPokemon
    check gameState.currentPokemonName == "No.0133 eevee (イーブイ)"
    gameState.setNextPokemon
    check gameState.currentPokemonName == ""
  
  test "isFinished":
    check gameState.isFinished == false
    gameState.setNextPokemon
    check gameState.isFinished == false
    gameState.setNextPokemon
    check gameState.isFinished == true

suite "typing test":
  setup:
    let party: seq[Pokemon] = @[
      newPokemon(
        id = 1,
        name = "hoge",
        localName = "hoge",
        flavorText = "one two*three",
        localFlavorText = "テキスト"
      ),
    ]
    let gameState = newGameState(party)
  
  test "perfect score":
    let typedCorrectly = "one two three"
    for str in typedCorrectly:
      gameState.update(newKey($str))
    check gameState.status == PlayStatus.finished
    check gameState.score.corrects == typedCorrectly.len
    check gameState.score.wrongs == 0
    check gameState.score.keypresses == typedCorrectly.len
  
  test "all wrong score":
    let typedWrongly = "xxxxxxxxxxxxxxxxx"
    let expectedKeypressses = gameState.currentText.len
    for str in typedWrongly:
      gameState.update(newKey($str))
    check gameState.status == PlayStatus.finished
    check gameState.score.corrects == 0
    check gameState.score.wrongs == expectedKeypressses
    check gameState.score.keypresses == expectedKeypressses
  
  test "correct and wrong score":
    let typedSomething = "onexxxxxxxxxxxxxx"
    let expectedKeypressses = gameState.currentText.len
    for str in typedSomething:
      gameState.update(newKey($str))
    check gameState.status == PlayStatus.finished
    check gameState.score.corrects == "one".len
    check gameState.score.wrongs == expectedKeypressses - "one".len
    check gameState.score.keypresses == expectedKeypressses