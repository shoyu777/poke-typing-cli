import
  domain/pokemon_repository_interface,
  infrastructure/api_pokemon_repository

type DiContainer* = tuple
  pokemonRepository: IPokemonRepository

proc newDiContainer*(): DiContainer =
  return (
    # DIコンテナによってローカルのオフラインデータと切り替えができるようになる(オフラインは未実装)
    # pokemonRepository: newLocalPokemonRepository.toInterface(),
    pokemonRepository: newApiPokemonRepository().toInterface(),
  )

let di* = newDiContainer()