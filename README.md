# Typing plactice with Pokémon on your terminal.

- This is a typing plactice app on CLI with Pokemon.
- Built with Nim.
- Pokémon data is collected from [PokéAPI](https://pokeapi.co/)

# Demo

# Usage
```bash
./poketyping [optional-params]

# example
./bin/poketyping -n 3 -l ja
```

## Options
### -n [int]

The number of Pokemon you want to buttle with.

It must be from 1 to 6.

```bash
# example
./bin/poketyping -n 3
```

### -l [language code]

Subtitle is shown during typing.

It must be one of ja, fr, ko, de, zh-Hans, zh-Hant, es, it, and cs.

```nim
const SUPPORTED_SUB_LANGUAGE* = @[
  "ja",      # 日本語        Japanese
  "fr",      # フランス語     French
  "ko",      # 韓国語        Korean
  "de",      # ドイツ語      German
  "zh-Hans", # 中国語(簡体字) Chinese
  "zh-Hant", # 中国語(繁体字) Chinese
  "es",      # スペイン語     Spanish
  "it",      # イタリア語     Italian
  "cs",      # チェコ語      Czech
]
```

```bash
# example
./bin/poketyping -l ja
```

# License

MIT.

# About Pokémon and PokéAPI

## Pokémon
Pokémon and Pokémon character names are trademarks of Nintendo.

## PokéAPI
[PokéAPI Site](https://pokeapi.co/)

Copyright (c) © 2013–2021 Paul Hallett and PokéAPI contributors (https://github.com/PokeAPI/pokeapi#contributing).
