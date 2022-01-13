{ sources ? import ./sources.nix { }
, haskellNix ? import sources.haskell-nix { }
, pkgs ? import haskellNix.sources.nixpkgs-unstable haskellNix.nixpkgsArgs
}: pkgs.callPackage ./ghc.nix {
  src = pkgs.fetchFromGitLab {
    owner = "ghc";
    repo = "ghc";
    rev = "81a8f7a7daeb87db53d598ced4b303f8f320442f";
    domain = "gitlab.haskell.org";
    fetchSubmodules = true;
    hash = "sha512-VqkeRoUUFWbSv9m85ztoEWXiBZdJjqnK90nKoimcWOypwHJBLkDVmd7RyLv9G2Hdf925MHEa8SukFFAiu5rXoA==";
  };
  llvmPackages = pkgs.llvmPackages_latest;
  stdenv = pkgs.llvmPackages_latest.stdenv;
  docs = "none";
  broken-test = ["T13366" "ghcilink003"];
}
