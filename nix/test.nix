{ sources ? import ./sources.nix { }
, haskellNix ? import sources.haskell-nix { }
, pkgs ? import haskellNix.sources.nixpkgs-unstable haskellNix.nixpkgsArgs
}: pkgs.callPackage ./ghc.nix {
  src = pkgs.fetchFromGitLab {
    owner = "ghc";
    repo = "ghc";
    rev = "aa50e118b201ae4ac2714afb998d430c9a4a9caa";
    domain = "gitlab.haskell.org";
    fetchSubmodules = true;
    hash = "sha512-VW1iXsQIW4H/xbNZkdqBlSCcHVGLWt70CcIjB+fzV/4XHHTBjAOyryfSYTLWpAqgWuCMi41ya9Ou2VlEfnkPiQ==";
  };
  llvmPackages = pkgs.llvmPackages_latest;
  stdenv = pkgs.llvmPackages_latest.stdenv;
  docs = "none";
  broken-test = ["T13366" "ghcilink003"];
}
