import std/httpclient
import std/json
import std/sequtils
import std/strutils

func sanitize(text: string): string =
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
  for i in 1..2:
    let jsonNode = parseJson(client.getContent("https://pokeapi.co/api/v2/pokemon-species/" & $i))
    let flavorText: string = jsonNode["flavor_text_entries"].filterIt(it["language"]["name"].getStr() == "en" and it["version"]["name"].getStr() == "sword")[0]["flavor_text"].getStr()
    result.members.add(Pokemon(
      id: jsonNode["id"].getInt(),
      name: jsonNode["name"].getStr(),
      flavorText: flavorText.sanitize(),
      textSize: flavorText.len))

func count*(self: Party): int =
  return self.members.len