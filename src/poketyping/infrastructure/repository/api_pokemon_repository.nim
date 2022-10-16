from ../../util/constants import POKE_API_URL, MAX_POKEMON_NUMBER
from ../../util/utils import genRandomIds
import
  std/httpclient,
  std/json,
  std/asyncdispatch,
  std/strutils,
  json_node_util,
  interface_implements,
  ../../domain/pokemon_repository_interface,
  ../../domain/game_option,
  ../../domain/pokemon,
  ../../domain/value_objects

type ApiPokemonRepository* = ref object
  path: string
  option: GameOption

func newApiPokemonRepository*(option: GameOption): ApiPokemonRepository =
  return ApiPokemonRepository(path: POKE_API_URL, option: option)

implements ApiPokemonRepository, IPokemonRepository:
  proc getRamdomPokemons*(self: ApiPokemonRepository): Future[seq[Pokemon]] {.async.} =
    let client = newAsyncHttpClient()
    let randIds: seq[int] = genRandomIds(count = self.option.numOfPokemon.get, maxRange = MAX_POKEMON_NUMBER)
    for id in randIds:
      let jsonNode = parseJson(await client.getContent(self.path & $id))
      let targetVersion = getMostWorldWideVersion(jsonNode)
      let flavorText = jsonNode.getFlavorText(version = targetVersion)
      let localFlavorText = jsonNode.getFlavorText(version = targetVersion, lang = $self.option.lang)
      result.add(
        newPokemon(
          id = jsonNode["id"].getInt(),
          name = jsonNode["name"].getStr(),
          localName = jsonNode.getLocalName($self.option.lang),
          flavorText = flavorText.sanitize.wordWrap,
          localFlavorText = localFlavorText.replace("\n", "*")
        )
      )
