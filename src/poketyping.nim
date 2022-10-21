from poketyping/util/constants import ERROR_MSGS
from poketyping/util/constants import SUPPORTED_SUB_LANGUAGE
import
  poketyping/application/typing_usecase,
  poketyping/domain/game_option,
  poketyping/presentation/view,
  cligen

# cligen setting
clCfg.version = "0.1.0"
clCfg.helpSyntax = ""

proc poketyping(num: int = 6, sub: string = "") =
  ## ◓ Typing Practice App with Pokemon ◓
  if num < 1 or 6 < num:
    raise newException(HelpError, $ERROR_MSGS.ARG_ERR & $ERROR_MSGS.NUM_ERR & "\n\n${HELP}")
  
  if not (SUPPORTED_SUB_LANGUAGE.contains(sub) or sub == ""):
    raise newException(HelpError, $ERROR_MSGS.ARG_ERR & $ERROR_MSGS.SUB_ERR & "\n\n${HELP}")
  
  let option = newGameOption(num = num, sub = sub)
  let typingUseCase = newTypingUseCase(option)
  let gaveView = newGameView(useCase = typingUseCase)
  gaveView.render

when isMainModule:
  dispatch(
    poketyping,
    help={
      "help": "print this poketyping help",
      "num": "Nums of Pokemons(1 to 6). Default 6.",
      "sub": "Choose subtitle if you need.(only ja, fn, ch)",
    }
  )