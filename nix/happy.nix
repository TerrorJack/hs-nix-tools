{ bootghc, haskell-nix }:
haskell-nix.hackage-tool {
  name = "happy";
  version = "1.20.0";
  compiler-nix-name = bootghc;
  index-state = haskell-nix.internalHackageIndexState;
}
