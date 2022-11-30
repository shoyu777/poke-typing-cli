# Typing plactice with Pokémon on your terminal.

- This is a typing plactice app on CLI with Pokemon.
- Built with Nim.
- Pokémon data is collected from [PokéAPI](https://pokeapi.co/)
- Windows console not supported. Please use Docker instead.

# Demo
![poketyping_demo](https://user-images.githubusercontent.com/7047398/204245889-762d7af6-1393-44f9-a0d5-26548a4eb5ae.gif)
# Install
Build and Run by Docker
- git clone this repository
- `docker pull nimlang/nim`
- `cd poke-typing-cli`
- ```docker run --platform linux/x86_64 --rm -v `pwd`:/usr/src/app -w /usr/src/app -i -t nimlang/nim nimble build -y```
- ```docker run --platform linux/x86_64 --rm -v `pwd`:/usr/src/app -w /usr/src/app -i -t nimlang/nim ./bin/poketyping -n 3 -l ja```

Build by yourself
- git clone this repository
- install nim
- `nimble build` at project root
- use `/bin/poketyping`

You can also use release build package from release page(Mac OS only). You may need to permit this binary file for execution after download.
# Usage
```bash
./poketyping [optional-params]

# example
./poketyping -n 3 -l ja
```

## Options
### -n [int]

The number of Pokemon you want to buttle with.

It must be from 1 to 6.

```bash
# example
./poketyping -n 3
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
./poketyping -l ja
```

# License

MIT.

# About Pokémon and PokéAPI

## Pokémon
Pokémon and Pokémon character names are trademarks of Nintendo.

## PokéAPI
[PokéAPI Site](https://pokeapi.co/)

Copyright (c) © 2013–2021 Paul Hallett and PokéAPI contributors (https://github.com/PokeAPI/pokeapi#contributing).
