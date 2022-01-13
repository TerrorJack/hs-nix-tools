{ autoconf
, automake
, bootghc ? "ghc8107"
, broken-test ? [ ]
, callPackage
, docs ? "no-sphinx-pdfs"
, flavour ? "validate+debug_info+split_sections"
, git
, haskell-nix
, lib
, llvmPackages
, m4
, ncurses
, perl
, sphinx
, src
, stdenv
, stdenvNoCC
, test-speed ? "normal"
, version ? "9.3"
, which
}:
let
  alex = callPackage ./alex.nix { inherit bootghc; };
  env = {
    AR = "${llvmPackages.llvm}/bin/llvm-ar";
    CC = "${stdenv.cc}/bin/cc";
    # CONF_GCC_LINKER_OPTS_STAGE2 = "-fuse-ld=${llvmPackages.lld}/bin/ld.lld";
    LD = "${llvmPackages.lld}/bin/ld.lld";
    LLC = "${llvmPackages.llvm}/bin/llc";
    NM = "${llvmPackages.llvm}/bin/llvm-nm";
    OPT = "${llvmPackages.llvm}/bin/opt";
    RANLIB = "${llvmPackages.llvm}/bin/llvm-ranlib";
  };
  ghc = haskell-nix.compiler."${bootghc}";
  hadrian = callPackage ./hadrian.nix {
    inherit bootghc;
    src = haskell-nix.haskellLib.cleanGit {
      name = "hadrian-src";
      src = src;
      subDir = "hadrian";
    };
  };
  happy = callPackage ./happy.nix { inherit bootghc; };
  hscolour = callPackage ./hscolour.nix { inherit bootghc; };
  result = stdenvNoCC.mkDerivation ({
    pname = "ghc";
    inherit version src;

    postPatch = "patchShebangs .";

    outputs = [ "out" "build" ];

    nativeBuildInputs =
      [ alex autoconf automake ghc hadrian happy hscolour m4 sphinx which ];

    LANG = "C.utf8";

    preConfigure = ''
      ./boot --hadrian
    '';

    configureFlags = [
      "--with-curses-includes=${ncurses.dev}/include"
      "--with-curses-libraries=${ncurses}/lib"
      "--with-intree-gmp"
    ] ++ [ "--disable-dwarf-unwind" ] ++ [ "--disable-numa" ];

    buildPhase = ''
      hadrian \
        --docs=${docs} \
        --flavour=${flavour} \
        --prefix=$out \
        -j$NIX_BUILD_CORES \
        install

      mkdir $build
      tar \
        --sort=name \
        --owner=0 \
        --group=0 \
        --numeric-owner \
        -cf $build/source.tar \
        -C .. \
        $(basename $PWD)
    '';

    dontInstall = true;
    dontFixup = true;

    passthru.tests = { inherit validate; };

    hardeningDisable = [ "all" ];
    requiredSystemFeatures = [ "big-parallel" ];
    strictDeps = true;
  } // env);
  validate = stdenv.mkDerivation ({
    name = "ghc-${version}-validate";
    src = "${result.build}/source.tar";

    nativeBuildInputs = [ git hadrian perl which ];

    dontConfigure = true;

    buildPhase = ''
      mkdir $out
      hadrian \
        --docs=${docs} \
        --flavour=${flavour} \
        -j$NIX_BUILD_CORES \
        --broken-test=${lib.escapeShellArg broken-test} \
        --summary=$out/testsuite_summary.txt \
        --summary-junit=$out/testsuite.xml \
        --test-compiler=${result}/bin/ghc \
        --test-have-intree-files \
        --test-speed=${test-speed} \
        test
    '';

    dontInstall = true;

    hardeningDisable = [ "all" ];
    requiredSystemFeatures = [ "big-parallel" ];
  } // env);
in
result
