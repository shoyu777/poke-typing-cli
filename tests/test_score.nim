import unittest
import
  poketyping/domain/score

suite "gamestate":
  test "score1":
    var score: Score = newScore(
      corrects = 10,
      wrongs = 10,
      keypresses = 20,
      seconds = 20,
      defeatedPokemons = @[]
    )
    check score.accuracy == 50
    check score.wpm == 60

  test "score2":
    var score: Score = newScore(
      corrects = 11,
      wrongs = 10,
      keypresses = 21,
      seconds = 20,
      defeatedPokemons = @[]
    )
    check score.accuracy == 52
    check score.wpm == 63