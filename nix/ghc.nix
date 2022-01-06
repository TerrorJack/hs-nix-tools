{ autoconf
, automake
, bootghc ? "ghc8107"
, callPackage
, flavour ? "validate"
, git
, haskell-nix
, llvmPackages
, m4
, ncurses
, numactl
, perl
, python3
, src
, stdenv
, version ? "9.3"
, which
}:
let
  alex = callPackage ./alex.nix { inherit bootghc; };
  ghc = haskell-nix.compiler."${bootghc}";
  hadrian = callPackage ./hadrian.nix {
    inherit bootghc;
    src = haskell-nix.haskellLib.cleanGit {
      name = "hadrian-src";
      inherit src;
      subDir = "hadrian";
    };
  };
  happy = callPackage ./happy.nix { inherit bootghc; };
  result = stdenv.mkDerivation {
    pname = "ghc";
    inherit version src;

    postPatch = "patchShebangs .";

    outputs = [ "out" "build" ];

    nativeBuildInputs =
      [ alex autoconf automake ghc hadrian happy m4 python3 which ];

    preConfigure = ''
      export AR=$(which $AR)
      export CC=$(which $CC)
      export LD=$(which $LD)
      export LLC=${llvmPackages.llvm}/bin/llc
      export OPT=${llvmPackages.llvm}/bin/opt
      export RANLIB=$(which $RANLIB)

      ./boot --hadrian
    '';

    configureFlags = [
      "--with-curses-includes=${ncurses.dev}/include"
      "--with-curses-libraries=${ncurses}/lib"
      "--with-intree-gmp"
      "--with-libnuma-includes=${numactl}/include"
      "--with-libnuma-libraries=${numactl}/lib"
    ];

    buildPhase = ''
      hadrian \
        --docs=none \
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
        -C $NIX_BUILD_TOP \
        source
    '';

    dontInstall = true;

    passthru.tests = { inherit test; };

    hardeningDisable = [ "all" ];
    requiredSystemFeatures = [ "big-parallel" ];
    strictDeps = true;
  };
  test = stdenv.mkDerivation {
    name = "ghc-${version}-test";
    src = "${result.build}/source.tar";

    nativeBuildInputs = [
      git
      hadrian
      perl
      python3
      which
    ];

    dontConfigure = true;

    buildPhase = ''
      mkdir $out
      hadrian \
        --docs=none \
        --flavour=${flavour} \
        -j$NIX_BUILD_CORES \
        --summary=$out/testsuite_summary.txt \
        --summary-junit=$out/testsuite.xml \
        --test-compiler=${result}/bin/ghc \
        --test-have-intree-files \
        --test-speed=normal \
        test
    '';

    dontInstall = true;

    hardeningDisable = [ "all" ];
    requiredSystemFeatures = [ "big-parallel" ];
  };
in
result
