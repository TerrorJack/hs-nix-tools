{ sources ? import ./sources.nix { }
, haskellNix ? import sources.haskell-nix { }
, pkgs ? import haskellNix.sources.nixpkgs-unstable haskellNix.nixpkgsArgs
}: pkgs.callPackage ./ghc.nix {
  src = pkgs.fetchFromGitLab {
    owner = "ghc";
    repo = "ghc";
    rev = "1de94daaf3d9bd03b1a641cc28678de224662738";
    domain = "gitlab.haskell.org";
    fetchSubmodules = true;
    hash = "sha512-3sUIcTkerwMb0Ep9ynrE+tbw9g8goPJwQUARbZoWVBggS/mt2JQvQ8gtudoT4/q7riqB95jzeq/vkTiavlRzQg==";
  };
  llvmPackages = pkgs.llvmPackages_12;
}
