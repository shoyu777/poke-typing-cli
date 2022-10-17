import widget

type ColumnWidget* = ref object of Widget
  children: seq[Widget]

func newColumnWidget*(children: seq[Widget]): ColumnWidget =
  return ColumnWidget(children: children)

method render*(self: ColumnWidget) =
  for child in self.children:
    child.render