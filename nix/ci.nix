{ sources ? import ./sources.nix { }
, haskellNix ? import sources.haskell-nix { }
, pkgs ? import haskellNix.sources.nixpkgs-unstable haskellNix.nixpkgsArgs
, ghcs ? [ "ghc865" "ghc884" "ghc8107" "ghc901" "ghc921" ]
, miscPkgs ? [ ]
}:
pkgs.runCommand "hs-nix-tools-ci"
{
  paths = map (pkg: pkgs."${pkg}") miscPkgs ++ pkgs.lib.concatMap
    (ghc:
      [ pkgs.haskell-nix.compiler."${ghc}" ]
        ++ pkgs.lib.attrValues (import ../default.nix { inherit ghc; }))
    ghcs ++ [
    (pkgs.haskell-nix.tool "ghc8107" "hoogle" {
      version = "5.0.18.2";
      index-state = pkgs.haskell-nix.internalHackageIndexState;
    })
  ];
} "export > $out"
