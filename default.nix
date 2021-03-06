{ sources ? import ./nix/sources.nix { }
, haskellNix ? import sources.haskell-nix { }
, pkgs ? import haskellNix.sources.nixpkgs-unstable haskellNix.nixpkgsArgs
, ghc ? "ghc8107"
, toolsGhc ? "ghc8107"
, supportedGhcs ? [ "ghc865" "ghc884" "ghc8107" "ghc901" "ghc921" ]
, modules ? [ ]
}:
let
  ghc_ver = compiler-nix-name:
    pkgs.haskell-nix.compiler."${compiler-nix-name}".version;
  ghc_9 = compiler-nix-name:
    pkgs.lib.versionAtLeast (ghc_ver compiler-nix-name) "9";
  mk_hls_pkg_set = compiler-nix-name:
    pkgs.haskell-nix.cabalProject rec {
      src = sources.haskell-language-server;
      cabalProject = builtins.readFile (if ghc_9 compiler-nix-name then
        "${src}/cabal-ghc901.project"
      else
        "${src}/cabal.project");
      configureArgs =
        "--disable-benchmarks --disable-tests -fall-formatters -fall-plugins";
      inherit compiler-nix-name modules;
    };
  hls_pkg_sets = pkgs.lib.genAttrs supportedGhcs mk_hls_pkg_set;
  mk_hls_tool = ghc: name: mk_hls_tool' ghc name name;
  mk_hls_tool' = ghc: pkg: name:
    if ghc_9 ghc then
      null
    else
      (hls_pkg_sets."${ghc}")."${pkg}".components.exes."${name}";
  mk_tool = name: mk_tool' toolsGhc name;
  mk_tool' = compiler-nix-name: name:
    pkgs.haskell-nix.hackage-tool {
      inherit name modules compiler-nix-name;
      index-state = "2021-12-29T12:30:08Z";
    };
in
{
  aeson-pretty = mk_hls_tool toolsGhc "aeson-pretty";
  brittany = mk_hls_tool toolsGhc "brittany";
  cabal = pkgs.haskell-nix.internal-cabal-install;
  cabal-docspec = (pkgs.haskell-nix.cabalProject {
    src = pkgs.applyPatches {
      name = "cabal-extras-src";
      src = sources.cabal-extras;
      patches = [ ./nix/cabal-extras.diff ];
    };
    compiler-nix-name = toolsGhc;
    configureArgs = "--disable-benchmarks --disable-tests --minimize-conflict-set";
    index-state = "2021-12-29T12:30:08Z";
    modules = modules ++ [{ reinstallableLibGhc = true; }];
    sha256map = {
      "https://github.com/phadej/gentle-introduction.git"."176cddab26a446bea644229c2e3ebf9e7b922559" =
        "sha256-8aJWeWeQ7AssOB+kDhAP0z/KuI0n1//2tybY4qK143o=";
      "https://github.com/phadej/warp-wo-x509.git"."98648f7520d228e6a14747223f0bbd68620b9318" =
        "sha256-w8UWW/rOIhzDAF54RkXyb21/39GPA8trJY7U4pHppXY=";
      "https://github.com/phadej/hooglite.git"."18856375932f6744cac7849bd1e816538537863f" =
        "sha256-awshX2MluKr4AE+IcyIGujVLs9m1r8yB6+VBh8dQag8=";
    };
  }).cabal-docspec.components.exes.cabal-docspec;
  cabal-fmt = mk_tool "cabal-fmt";
  cpphs = mk_hls_tool toolsGhc "cpphs";
  floskell = mk_hls_tool toolsGhc "floskell";
  fourmolu = mk_hls_tool toolsGhc "fourmolu";
  friendly = mk_tool "friendly";
  gen-hie = mk_hls_tool' toolsGhc "implicit-hie" "gen-hie";
  ghcid = mk_tool "ghcid";
  ghcide = mk_hls_tool ghc "ghcide";
  haskell-language-server = mk_hls_tool ghc "haskell-language-server";
  hie-bios = mk_hls_tool ghc "hie-bios";
  hiedb = mk_hls_tool ghc "hiedb";
  hindent = mk_tool "hindent";
  hlint = mk_hls_tool toolsGhc "hlint";
  hpack = pkgs.runCommand "hpack" { } ''
    mkdir -p $out/bin
    ln -s $(realpath ${pkgs.haskell-nix.internal-nix-tools}/bin/hpack) $out/bin/hpack
  '';
  HsColour = mk_hls_tool' toolsGhc "hscolour" "HsColour";
  ormolu = mk_hls_tool toolsGhc "ormolu";
  ppsh = (pkgs.haskell-nix.hackage-package {
    name = "pretty-show";
    compiler-nix-name = toolsGhc;
    index-state = "2021-12-29T12:30:08Z";
    inherit modules;
  }).components.exes.ppsh;
  refactor = mk_hls_tool' toolsGhc "apply-refact" "refactor";
  retrie = mk_hls_tool toolsGhc "retrie";
  stylish-haskell = mk_hls_tool toolsGhc "stylish-haskell";
  weeder =
    if pkgs.lib.versionAtLeast (ghc_ver ghc) "8.10" && !(ghc_9 ghc) then
      (pkgs.haskell-nix.hackage-package {
        name = "weeder";
        version = "2.2.0";
        compiler-nix-name = ghc;
        index-state = "2021-12-29T12:30:08Z";
        inherit modules;
      }).components.exes.weeder
    else
      null;
}
