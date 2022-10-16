from core/util/constants import ERROR_MSGS
import core/game
import cligen

# cligen setting
clCfg.version = "0.1.0"
clCfg.helpSyntax = ""

proc poketyping(num: int = 6, sub: string = "") =
  ## ◓ Typing Practice App with Pokemon ◓
  if num < 1 or 6 < num:
    raise newException(HelpError, $ERROR_MSGS.ARG_ERR & $ERROR_MSGS.NUM_ERR & "\n\n${HELP}")
  battleStart(n = num, sub = sub)

when isMainModule:
  dispatch(
    poketyping,
    help={
      "help": "print this poketyping help",
      "num": "Nums of Pokemons(1 to 6). Default 6.",
      "sub": "Choose subtitles if you need.(only ja, fn, ch)",
    }
  )