import std/httpclient
import std/json
import std/sequtils
import std/strutils
import utils

func sanitized(text: string): string =
  # 改行削除、フレームのちょうど良い長さで折り返し記号「*」をつける
  return text.replace("\n", "*").replace("é", "e")

type Pokemon* = ref object
  id*: int
  name*: string
  flavorText*: string
  textSize*: int

type Party* = ref object
  members*: seq[Pokemon]

proc newParty*(): Party =
  new result
  let client = newHttpClient()
  for i in 1..6:
    let jsonNode = parseJson(client.getContent("https://pokeapi.co/api/v2/pokemon-species/" & $i))
    let flavorText: string = jsonNode["flavor_text_entries"].filterIt(it["language"]["name"].getStr() == "en" and it["version"]["name"].getStr() == "sword")[0]["flavor_text"].getStr()
    result.members.add(Pokemon(
      id: jsonNode["id"].getInt(),
      name: jsonNode["name"].getStr(),
      flavorText: flavorText.sanitized(),
      textSize: flavorText.len))

