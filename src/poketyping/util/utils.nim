proc present*[T](s: seq[T]): bool =
  return s.len > 0

proc first*[T](s: seq[T]): T =
  return s[0]

proc drop*[T](s: seq[T], i: int = 1): seq[T] =
  if s.len > i:
    return s[i .. ^1]
  else:
    return @[]

import std/random
proc genRandomIds*(count: int, maxRange: int): seq[int] =
  randomize()
  while result.len < count:
    let num = rand(1 .. maxRange)
    if not result.contains(num):
      result.add(num)