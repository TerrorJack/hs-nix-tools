{ sources ? import ./sources.nix { }
, haskellNix ? import sources.haskell-nix { }
, pkgs ? import haskellNix.sources.nixpkgs-unstable haskellNix.nixpkgsArgs
}: pkgs.callPackage ./ghc.nix {
  src = pkgs.fetchFromGitLab {
    owner = "ghc";
    repo = "ghc";
    rev = "978ea35e37b49ffde28b0536e44362b66f3187b4";
    domain = "gitlab.haskell.org";
    fetchSubmodules = true;
    hash = "sha512-84Nej29Argc53gwuFRLDMVRChsE2PI/ZhuV+QXzO2Sx1QFrEu//wo+LdiB9UDI5HoZEOsAl5exxt/Nv0j4dysQ==";
  };
  llvmPackages = pkgs.llvmPackages_12;
}
