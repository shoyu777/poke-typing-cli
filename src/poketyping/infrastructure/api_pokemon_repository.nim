from ../util/constants import POKE_API_URL, MAX_POKEMON_NUMBER
from ../util/utils import genRandomIds
import
  std/httpclient,
  std/json,
  std/strutils,
  json_node_util,
  interface_implements,
  ../domain/pokemon_repository_interface,
  ../domain/game_option,
  ../domain/pokemon

type ApiPokemonRepository* = ref object
  path: string

func newApiPokemonRepository*(): ApiPokemonRepository =
  return ApiPokemonRepository(path: POKE_API_URL)

implements ApiPokemonRepository, IPokemonRepository:
  proc getRamdomPokemons(self: ApiPokemonRepository, gameOption: GameOption): seq[Pokemon] =
    let client = newHttpClient()
    let randIds: seq[int] = genRandomIds(count = gameOption.numOfPokemon, maxRange = MAX_POKEMON_NUMBER)
    for id in randIds:
      let jsonNode = parseJson(client.getContent(self.path & $id))
      let targetVersion = getMostWorldWideVersion(jsonNode)
      let flavorText = jsonNode.getFlavorText(version = targetVersion)
      let localFlavorText = jsonNode.getFlavorText(version = targetVersion, lang = gameOption.lang)
      result.add(
        newPokemon(
          id = jsonNode["id"].getInt(),
          name = jsonNode["name"].getStr(),
          localName = jsonNode.getLocalName(gameOption.lang),
          flavorText = flavorText.sanitize.wordWrap,
          localFlavorText = localFlavorText.replace("\n", "*")
        )
      )
