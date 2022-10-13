# Package

version       = "0.1.0"
author        = "shoyu777"
description   = "Typing Plactice App with Pokemon."
license       = "MIT"
srcDir        = "src"
binDir        = "bin"
skipDirs      = @["tests"]
bin           = @["poketyping"]


# Dependencies

requires "nim >= 1.6.8"
requires "cligen >= 1.5.28"
requires "wcwidth >= 0.1.3"

# tasks
import strformat

task archive, "Create archived assets":
  rmDir "dist"
  let app = "poketyping"
  let assets = &"{app}_{buildOS}"
  let dir = &"dist/{assets}"
  mkDir &"{dir}/bin"
  cpFile &"bin/{app}", &"{dir}/bin/{app}"
  cpFile "LICENSE", &"{dir}/LICENSE"
  cpFile "README.md", &"{dir}/README.md"
  exec &"chmod 755 {dir}/bin/{app}"
  withDir "dist":
    exec &"tar czf {assets}.tar.gz {assets}"