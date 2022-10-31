import widget

type PureTextWidget* = ref object of Widget
  text: string

func newPureTextWidget*(text: string): PureTextWidget =
  return PureTextWidget(text: text)

method render*(self: PureTextWidget) =
  stdout.write(self.text & "\n")
