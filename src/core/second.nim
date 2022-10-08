type Parson* = ref object
  name: string
proc newParson*(name: string): Parson =
  new result
  result.name = name
proc getName*(self: Parson): string =
  return self.name
