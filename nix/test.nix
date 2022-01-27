{ sources ? import ./sources.nix { }
, haskellNix ? import sources.haskell-nix { }
, pkgs ? import haskellNix.sources.nixpkgs-unstable haskellNix.nixpkgsArgs
}:
pkgs.callPackage ./ghc.nix {
  src = pkgs.haskell-nix.haskellLib.cleanGit {
    name = "ghc-src";
    src = /home/cheng/ghc-head;
  };
  llvmPackages = pkgs.llvmPackages_latest;
  stdenv = pkgs.llvmPackages_latest.stdenv;
  bintools = pkgs.llvmPackages_latest.bintools;
  docs = "none";
  broken-test = [ "T13366" "ghcilink003" ];
}
