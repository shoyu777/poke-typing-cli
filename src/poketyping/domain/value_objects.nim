from ../util/constants import SUPPORTED_SUB_LANGUAGE
import ../errors

type NumOfPokemon* = ref object
  value: Natural

func newNumOfPokemon*(num: Natural = 6): NumOfPokemon =
  if 0 < num and num <= 6:
    return NumOfPokemon(value: num)
  else:
    raise newException(DomainError, "Number of Pokemon must be from 1 to 6. Please check --help")

func get*(self: NumOfPokemon): Natural =
  return self.value


type Language* = ref object
  value: string

func newLanguage*(lang: string = ""): Language =
  if SUPPORTED_SUB_LANGUAGE.contains(lang) or lang == "":
    return Language(value: lang)
  else:
    raise newException(DomainError, "Language " & lang & " is not supported. Please check --help")

func `$`*(self: Language): string =
  return self.value  