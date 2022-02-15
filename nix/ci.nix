{ sources ? import ./sources.nix { }
, haskellNix ? import sources.haskell-nix { }
, pkgs ? import haskellNix.sources.nixpkgs-unstable haskellNix.nixpkgsArgs
, ghcs ? [ "ghc865" "ghc884" "ghc8107" "ghc902" "ghc921" ]
, miscPkgs ? [
    "binaryen"
    "nodejs-17_x"
    "nodejs-16_x"
    "nodejs-14_x"
    "nodejs-12_x"
    "util-linux"
    "wabt"
  ]
}:
pkgs.runCommand "hs-nix-tools-ci"
{
  paths = map (pkg: pkgs."${pkg}") miscPkgs ++ pkgs.lib.concatMap
    (ghc:
      [ pkgs.haskell-nix.compiler."${ghc}" ]
        ++ pkgs.lib.attrValues (import ./tools.nix { inherit ghc; }))
    ghcs ++ [
    (pkgs.haskell-nix.tool "ghc8107" "hoogle" {
      version = "5.0.18.2";
      index-state = pkgs.haskell-nix.internalHackageIndexState;
    })
  ];
} "export > $out"
