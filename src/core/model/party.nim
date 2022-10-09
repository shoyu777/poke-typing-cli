import
  std/httpclient,
  std/json,
  std/sequtils,
  std/strutils,
  pokemon

func sanitize(text: string): string =
  return text.replace("\n", "*").replace("é", "e")

type Party* = ref object
  members*: seq[Pokemon]

proc newParty*(n: int = 6, sub: string = ""): Party =
  new result
  let client = newHttpClient()
  for i in 1..n:
    let jsonNode = parseJson(client.getContent("https://pokeapi.co/api/v2/pokemon-species/" & $i))
    let flavorText: string = jsonNode["flavor_text_entries"].filterIt(it["language"]["name"].getStr() == "en" and it["version"]["name"].getStr() == "sword")[0]["flavor_text"].getStr()
    result.members.add(
      newPokemon(
        id = jsonNode["id"].getInt(),
        name = jsonNode["name"].getStr(),
        flavorText = flavorText.sanitize()
      )
    )

func count*(self: Party): int =
  return self.members.len