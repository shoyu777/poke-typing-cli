import ../../util/constants
import std/json
import std/sequtils
import std/strutils

func sanitize*(text: string): string =
  result = text
  for word in REPLACE_WORDS:
    result = result.replace(word[0], word[1])

func wordWrap*(text: string, lineWidth: int = 70): string =
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

proc getMostWorldWideVersion*(jsonNode: JsonNode): string =
  # 対応言語が最大のバージョンを探す
  var maxCount = 0
  var maxVersion = ""
  for version in POKEMON_VERSIONS:
    let count = jsonNode["flavor_text_entries"].filterIt(it["version"]["name"].getStr() == version).len
    if count >= maxCount:
      maxCount = count
      maxVersion = version

proc getFlavorText*(jsonNode: JsonNode, version: string, lang: string = "en"): string =
  let localFlavorTexts: seq[JsonNode] = jsonNode["flavor_text_entries"].filterIt(it["version"]["name"].getStr() == version and it["language"]["name"].getStr() == lang)
  if localFlavorTexts.len > 0:
    result = localFlavorTexts[0]["flavor_text"].getStr()

proc getLocalName*(jsonNode: JsonNode, lang: string): string =
  let localNames: seq[JsonNode] = jsonNode["names"].filterIt(it["language"]["name"].getStr() == lang)
  if localNames.len > 0:
    result = localNames[0]["name"].getStr()