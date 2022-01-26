{ sources ? import ./sources.nix { }
, haskellNix ? import sources.haskell-nix { }
, pkgs ? import haskellNix.sources.nixpkgs-unstable haskellNix.nixpkgsArgs
}:
pkgs.callPackage ./ghc.nix {
  src = pkgs.applyPatches {
    src = pkgs.fetchFromGitLab {
      owner = "ghc";
      repo = "ghc";
      rev = "781323a3076781b5db50bdbeb8f64394add43836";
      domain = "gitlab.haskell.org";
      fetchSubmodules = true;
      hash =
        "sha512-hJW7XNTQRbSLyrljlF2TsH3RRkmpSvEG56sRlnACSDLWQMEHgxi+rsqNVKest4Sy5DEG7M7gPKWrek4D3x6ebQ==";
    };
    patches = [ ./7426.patch ./ghc.diff ];
  };
  llvmPackages = pkgs.llvmPackages_latest;
  stdenv = pkgs.llvmPackages_latest.stdenv;
  bintools = pkgs.llvmPackages_latest.bintools;
  docs = "none";
  broken-test = [ "T13366" "ghcilink003" ];
}
