import poketyping/util/constants
import
  poketyping/application/typing_usecase,
  poketyping/domain/game_option,
  poketyping/presentation/view,
  cligen

# cligen setting
clCfg.version = "0.1.0"
clCfg.helpSyntax = ""

proc poketyping(num: int = 6, lang: string = "") =
  ## ◓◓◓ Typing Practice App with Pokemon ◓◓◓
  if num < 1 or 6 < num:
    raise newException(HelpError, $ERROR_MSGS.ARG_ERR & $ERROR_MSGS.NUM_ERR & "\n\n${HELP}")
  
  if not (SUPPORTED_SUB_LANGUAGE.contains(lang) or lang == ""):
    raise newException(HelpError, $ERROR_MSGS.ARG_ERR & $ERROR_MSGS.SUB_ERR & SUPPORTED_SUB_LANGUAGE.join(", ") & "\n\n${HELP}")
  
  let option = newGameOption(num = num, lang = lang)
  let typingUseCase = newTypingUseCase(option)
  let gaveView = newGameView(useCase = typingUseCase)
  gaveView.render

when isMainModule:
  dispatch(
    poketyping,
    help={
      "help": "print this poketyping help",
      "num": "Nums of Pokemons(1 to 6). Default 6.",
      "lang": "Choose subtitle if you need. \n(ONLY ja, fr, ko, de, zh-Hans, zh-Hant, es, it, cs)",
    }
  )