{ sources ? import ./sources.nix { }
, haskellNix ? import sources.haskell-nix { }
, pkgs ? import haskellNix.sources.nixpkgs-unstable haskellNix.nixpkgsArgs
}:
pkgs.callPackage ./ghc.nix {
  src = pkgs.applyPatches {
    src = pkgs.fetchFromGitLab {
      owner = "ghc";
      repo = "ghc";
      rev = "f0adea14316ef476607cb7d99f74875875e52b20";
      domain = "gitlab.haskell.org";
      fetchSubmodules = true;
      hash =
        "sha512-2cAkYAp5+xK6XBNKjsHEmWNZLoj6rYht90ypqnJ4+m5LMnthyknZRURCT3Vb5f9/hzouv061Ip9qff0wzt7Ing==";
    };
    patches = [ ./ghc.diff ];
  };
  llvmPackages = pkgs.llvmPackages_latest;
  stdenv = pkgs.llvmPackages_latest.stdenv;
  bintools = pkgs.llvmPackages_latest.bintools;
  docs = "none";
  broken-test = [ "T13366" "ghcilink003" ];
}
