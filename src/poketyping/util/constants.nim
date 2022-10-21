type KEYCODE* {.pure.} = enum
  CTRL_C = "\u0003"
  ESCAPE = "\u001B"
  BACKSPACE = "\u007f"

type COLORS* {.pure.} = enum
  BG_GREEN = "\x1b[42m"
  BG_RED = "\x1b[41m"
  RESET = "\x1b[0m"

type ERROR_MSGS* {.pure.} = enum
  ARG_ERR = "\n== Argument Error ==\n"
  NUM_ERR = "Num of Pokemon must be between 1 and 6."
  SUB_ERR = "Subtitle must be one of "

const POKE_API_URL* = "https://pokeapi.co/api/v2/pokemon-species/"

const MAX_POKEMON_NUMBER* = 905

const REPLACE_WORDS* = @[
  ["\n", " "],
  ["\f", " "],
  ["POKéMON", "Pokemon"],
  ["é", "e"],
  ["—", "-"],
  ["−", "-"],
  ["’", "'"],
  ["“", $'"']
]

const SUPPORTED_SUB_LANGUAGE* = @[
  "ja",      # 日本語
  "fr",      # フランス語
  "ko",      # 韓国語 Korean
  "de",      # ドイツ語 German
  "zh-Hans", # 中国語(簡体字) Chinese
  "zh-Hant", # 中国語(繁体字) Chinese
  "es",      # スペイン語 Spanish
  "it",      # イタリア語 Italian
  "cs",      # チェコ語 Czech
]

const POKEMON_VERSIONS* = @[
  "red",
  "blue",
  "yellow",
  "gold",
  "silver",
  "crystal",
  "ruby",
  "sapphire",
  "emerald",
  "firered",
  "leafgreen",
  "diamond",
  "pearl",
  "platinum",
  "heartgold",
  "soulsilver",
  "black",
  "white",
  "colosseum",
  "xd",
  "black-2",
  "white-2",
  "x",
  "y",
  "omega-ruby",
  "alpha-sapphire",
  "sun",
  "moon",
  "ultra-sun",
  "ultra-moon",
  "lets-go-pikachu",
  "lets-go-eevee",
  "sword",
  "shield",
  "the-isle-of-armor",
  "the-crown-tundra",
  "brilliant-diamond",
  "shining-pearl",
  "legends-arceus"
]