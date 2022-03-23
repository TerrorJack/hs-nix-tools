{ sources ? import ./sources.nix { }
, haskellNix ? import sources.haskell-nix { }
, pkgs ? import haskellNix.sources.nixpkgs-unstable haskellNix.nixpkgsArgs
, ghc ? "ghc8107"
, supportedGhcs ? [ "ghc865" "ghc884" "ghc8107" "ghc902" "ghc922" ]
}:
let
  ghc_ver = compiler-nix-name:
    pkgs.haskell-nix.compiler."${compiler-nix-name}".version;
  mk_hls_pkg_set = compiler-nix-name:
    let
      hls_project_file = {
        ghc922 = "cabal-ghc92.project";
      }."${compiler-nix-name}";
      modules = {
        ghc922 = [{
          nonReinstallablePkgs = [
            "rts"
            "ghc-heap"
            "ghc-prim"
            "integer-gmp"
            "integer-simple"
            "base"
            "deepseq"
            "array"
            "ghc-boot-th"
            "pretty"
            "template-haskell"
            "ghcjs-prim"
            "ghcjs-th"
            "ghc-bignum"
            "exceptions"
            "stm"
            "ghc-boot"
            "ghc"
            "Cabal"
            "Win32"
            "array"
            "binary"
            "bytestring"
            "containers"
            "directory"
            "filepath"
            "ghc-boot"
            "ghc-compact"
            "ghc-prim"
            "hpc"
            "mtl"
            "parsec"
            "process"
            "text"
            "time"
            "transformers"
            "unix"
            "xhtml"
            "terminfo"
          ];
        }];
      }."${compiler-nix-name}";
    in
    pkgs.haskell-nix.cabalProject rec {
      src = sources.haskell-language-server;
      cabalProject = builtins.readFile "${src}/${hls_project_file}";
      inherit compiler-nix-name modules;
      configureArgs = "--disable-benchmarks --disable-tests";
    };
  hls_pkg_sets = pkgs.lib.genAttrs supportedGhcs mk_hls_pkg_set;
  mk_hls_tool = ghc: name: mk_hls_tool' ghc name name;
  mk_hls_tool' = ghc: pkg: name:
    if pkgs.lib.elem ghc [ "ghc922" ] then
      (hls_pkg_sets."${ghc}")."${pkg}".components.exes."${name}"
    else
      null;
  mk_tool = compiler-nix-name: name:
    pkgs.haskell-nix.hackage-tool {
      inherit name compiler-nix-name;
    };
in
{
  brittany = pkgs.haskell-nix.hackage-tool {
    name = "brittany";
    compiler-nix-name = "ghc902";
    modules = [{
      nonReinstallablePkgs = [
        "rts"
        "ghc-heap"
        "ghc-prim"
        "integer-gmp"
        "integer-simple"
        "base"
        "deepseq"
        "array"
        "ghc-boot-th"
        "pretty"
        "template-haskell"
        "ghcjs-prim"
        "ghcjs-th"
        "ghc-bignum"
        "exceptions"
        "stm"
        "ghc-boot"
        "ghc"
        "Cabal"
        "Win32"
        "array"
        "binary"
        "bytestring"
        "containers"
        "directory"
        "filepath"
        "ghc-boot"
        "ghc-compact"
        "ghc-prim"
        "hpc"
        "mtl"
        "parsec"
        "process"
        "text"
        "time"
        "transformers"
        "unix"
        "xhtml"
        "terminfo"
      ];
    }];
  };
  cabal = pkgs.haskell-nix.internal-cabal-install;
  cabal-docspec = (pkgs.haskell-nix.cabalProject {
    src = pkgs.applyPatches {
      name = "cabal-extras-src";
      src = sources.cabal-extras;
      patches = [ ./cabal-extras.diff ];
    };
    compiler-nix-name = "ghc8107";
    configureArgs =
      "--disable-benchmarks --disable-tests --minimize-conflict-set";
    modules = [{ reinstallableLibGhc = true; }];
    sha256map = {
      "https://github.com/phadej/gentle-introduction.git"."176cddab26a446bea644229c2e3ebf9e7b922559" =
        "sha256-8aJWeWeQ7AssOB+kDhAP0z/KuI0n1//2tybY4qK143o=";
      "https://github.com/phadej/warp-wo-x509.git"."98648f7520d228e6a14747223f0bbd68620b9318" =
        "sha256-w8UWW/rOIhzDAF54RkXyb21/39GPA8trJY7U4pHppXY=";
      "https://github.com/phadej/hooglite.git"."18856375932f6744cac7849bd1e816538537863f" =
        "sha256-awshX2MluKr4AE+IcyIGujVLs9m1r8yB6+VBh8dQag8=";
    };
  }).cabal-docspec.components.exes.cabal-docspec;
  cabal-fmt = mk_tool "ghc8107" "cabal-fmt";
  floskell = mk_tool "ghc922" "floskell";
  fourmolu = mk_tool "ghc922" "fourmolu";
  friendly = mk_tool "ghc8107" "friendly";
  ghcid = mk_tool "ghc922" "ghcid";
  haskell-language-server = mk_hls_tool ghc "haskell-language-server";
  hiedb = mk_hls_tool ghc "hiedb";
  hindent = mk_tool "ghc902" "hindent";
  nix-tools = pkgs.haskell-nix.internal-nix-tools;
  ormolu = mk_tool "ghc922" "ormolu";
  ppsh = (pkgs.haskell-nix.hackage-package {
    name = "pretty-show";
    compiler-nix-name = "ghc922";
  }).components.exes.ppsh;
  stylish-haskell = pkgs.haskell-nix.hackage-tool {
    name = "stylish-haskell";
    compiler-nix-name = "ghc922";
    modules = [{
      nonReinstallablePkgs = [
        "rts"
        "ghc-heap"
        "ghc-prim"
        "integer-gmp"
        "integer-simple"
        "base"
        "deepseq"
        "array"
        "ghc-boot-th"
        "pretty"
        "template-haskell"
        "ghcjs-prim"
        "ghcjs-th"
        "ghc-bignum"
        "exceptions"
        "stm"
        "ghc-boot"
        "ghc"
        "Cabal"
        "Win32"
        "array"
        "binary"
        "bytestring"
        "containers"
        "directory"
        "filepath"
        "ghc-boot"
        "ghc-compact"
        "ghc-prim"
        "hpc"
        "mtl"
        "parsec"
        "process"
        "text"
        "time"
        "transformers"
        "unix"
        "xhtml"
        "terminfo"
      ];
    }];
  };
}
