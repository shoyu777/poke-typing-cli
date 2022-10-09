proc present*[T](s: seq[T]): bool =
  return s.len > 0

proc first*[T](s: seq[T]): T =
  return s[0]

proc drop*[T](s: seq[T], i: int = 1): seq[T] =
  if s.len > i:
    return s[i .. ^1]
  else:
    return @[]
