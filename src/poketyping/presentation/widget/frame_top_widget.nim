import
  std/strutils,
  std/terminal,
  widget,
  widget_util

type FrameTopWidget* = ref object of Widget
  totalPokemon: int
  remainingPokemon: int

func newFrameTopWidget*(totalPokemon: int, remainingPokemon: int): FrameTopWidget =
  return FrameTopWidget(totalPokemon: totalPokemon, remainingPokemon: remainingPokemon)

method render*(self: FrameTopWidget) =
  const maxPartyCount = 6
  stdout.write("╭" & "─".repeat(DEFAULT_SCREEN_WIDTH - 20) & "┨ ")
  # Defeated monster
  stdout.write("◓ ".repeat(self.totalPokemon - self.remainingPokemon))
  # Remained monster
  stdout.setForeGroundColor(fgRed)
  stdout.write("◓ ".repeat(self.remainingPokemon))
  stdout.setForeGroundColor(fgDefault)
  # Up to max(usually 6)
  stdout.write("◌ ".repeat(maxPartyCount - self.totalPokemon))
  stdout.write("┠───╮\n")