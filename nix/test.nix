{ sources ? import ./sources.nix { }
, haskellNix ? import sources.haskell-nix { }
, pkgs ? import haskellNix.sources.nixpkgs-unstable haskellNix.nixpkgsArgs
}: pkgs.callPackage ./ghc.nix {
  src = pkgs.fetchFromGitLab {
    owner = "ghc";
    repo = "ghc";
    rev = "92f3e6e4e30b853af304aa53f529af2c262419f1";
    domain = "gitlab.haskell.org";
    fetchSubmodules = true;
    hash = "sha512-2ocTwE+VXk9uvjzwxkt9BozikPGgAezTIIT+nRMFGcPt67uboFD/iDvOIp9mjXiW9T6+sLvOgwEinw13ASeRdw==";
  };
  llvmPackages = pkgs.llvmPackages_latest;
  stdenv = pkgs.llvmPackages_latest.stdenv;
  docs = "none";
  broken-test = ["T13366" "ghcilink003"];
}
