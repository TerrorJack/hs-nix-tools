{ bootghc, haskell-nix }:
(haskell-nix.hackage-package {
  name = "hscolour";
  version = "1.24.4";
  compiler-nix-name = bootghc;
  index-state = haskell-nix.internalHackageIndexState;
}).components.exes.HsColour
