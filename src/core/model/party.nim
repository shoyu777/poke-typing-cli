import
  std/httpclient,
  std/json,
  std/sequtils,
  std/strutils,
  std/random,
  pokemon,
  ../util/constants

func sanitize(text: string): string =
  result = text
  for word in replaceWords:
    result = result.replace(word[0], word[1])

func wordWrap(text: string, lineWidth: int = 70): string =
  let words = text.split(' ')
  for idx, word in words:
    if idx == 0:
      result.add(word)
    else:
      let currentLine = result.split('*')[^1]
      if currentLine.len + word.len + 1 > lineWidth:
        result.add("*" & word)
      else:
        result.add(" " & word)

proc genRandomIds(count: int, maxRange: int): seq[int] =
  randomize()
  while result.len < count:
    let num = rand(1 .. maxRange)
    if not result.contains(num):
      result.add(num)
  # for debugging
  # result = @[304]

proc getFlavorTexts(jsonNode: JsonNode, sub: string): (string, string) =
  # 言語が最大のバージョンを探す
  var maxCount = 0
  var maxVersion = ""
  for version in pokemonVersions:
    let count = jsonNode["flavor_text_entries"].filterIt(it["version"]["name"].getStr() == version).len
    if count >= maxCount:
      maxCount = count
      maxVersion = version
  # enとローカル言語の取得
  let flavorTexts: seq[JsonNode] = jsonNode["flavor_text_entries"].filterIt(it["version"]["name"].getStr() == maxVersion and it["language"]["name"].getStr() == "en")
  var flavorText = ""
  if flavorTexts.len > 0:
    flavorText = flavorTexts[0]["flavor_text"].getStr()
  let localFlavorTexts: seq[JsonNode] = jsonNode["flavor_text_entries"].filterIt(it["version"]["name"].getStr() == maxVersion and it["language"]["name"].getStr() == sub)
  var localFlavorText = ""
  if localFlavorTexts.len > 0:
    localFlavorText = localFlavorTexts[0]["flavor_text"].getStr()
  return (flavorText, localFlavorText)

type Party* = ref object
  members*: seq[Pokemon]

proc newParty*(n: int = 6, sub: string = ""): Party =
  new result
  let client = newHttpClient()
  let randIds: seq[int] = genRandomIds(count = n, maxRange = 905)
  for id in randIds:
    let jsonNode = parseJson(client.getContent("https://pokeapi.co/api/v2/pokemon-species/" & $id))
    # let flavorText: string = jsonNode["flavor_text_entries"].filterIt(it["language"]["name"].getStr() == "en")[0]["flavor_text"].getStr()
    let (flavorText, localFlavorText) = jsonNode.getFlavorTexts(sub)
    result.members.add(
      newPokemon(
        id = jsonNode["id"].getInt(),
        name = jsonNode["name"].getStr(),
        flavorText = flavorText.sanitize.wordWrap,
        localFlavorText = localFlavorText.replace("\n", "*")
      )
    )

func count*(self: Party): int =
  return self.members.len