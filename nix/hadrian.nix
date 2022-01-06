{ bootghc, haskell-nix, src }:
(haskell-nix.cabalProject {
  inherit src;
  compiler-nix-name = bootghc;
}).hadrian.components.exes.hadrian
