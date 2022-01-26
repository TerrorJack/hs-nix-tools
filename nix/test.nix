{ sources ? import ./sources.nix { }
, haskellNix ? import sources.haskell-nix { }
, pkgs ? import haskellNix.sources.nixpkgs-unstable haskellNix.nixpkgsArgs
}:
pkgs.callPackage ./ghc.nix {
  src = pkgs.applyPatches {
    src = pkgs.fetchFromGitLab {
      owner = "ghc";
      repo = "ghc";
      rev = "e840582943eaa49e739fc9d801d2f0925daac0a0";
      domain = "gitlab.haskell.org";
      fetchSubmodules = true;
      hash =
        "sha512-5jjRo3vIEggSI3MnAbn8GnMOJacfI7Q3cX/WFKNR2fIEgSn/W9+qwYD2BGBgpwMj3XyMfEqcfz25j+G4zGYFiA==";
    };
    patches = [ ./ghc.diff ];
  };
  llvmPackages = pkgs.llvmPackages_latest;
  stdenv = pkgs.llvmPackages_latest.stdenv;
  bintools = pkgs.llvmPackages_latest.bintools;
  docs = "none";
  broken-test = [ "T13366" "ghcilink003" ];
}
