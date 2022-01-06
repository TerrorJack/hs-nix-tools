{ bootghc, haskell-nix }:
haskell-nix.hackage-tool {
  name = "alex";
  version = "3.2.6";
  compiler-nix-name = bootghc;
  index-state = haskell-nix.internalHackageIndexState;
}
