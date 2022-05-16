{ autoPatchelfHook, gcc9Stdenv, gmp, libxml2, ncurses, stdenvNoCC, unzip }:
let
  wasi_sdk_src = builtins.fetchurl
    "https://nightly.link/WebAssembly/wasi-sdk/workflows/main/main/dist-ubuntu-latest.zip";
  libffi_wasm32_src = builtins.fetchurl
    "https://nightly.link/tweag/libffi-wasm32/workflows/shell/master/out.zip";
  wasm32_wasi_ghc_src = builtins.fetchTarball
    "https://gitlab.haskell.org/TerrorJack/ghc/-/jobs/artifacts/wasm32-wasi/raw/ghc-wasm32-wasi.tar.xz?job=wasm32-wasi-bindist";

  wasi_sdk = stdenvNoCC.mkDerivation {
    name = "wasi-sdk";

    buildInputs = [ gcc9Stdenv.cc.cc.lib libxml2 ncurses ];
    nativeBuildInputs = [ autoPatchelfHook unzip ];

    dontUnpack = true;

    installPhase = ''
      unzip ${wasi_sdk_src}
      mkdir $out
      tar xzf wasi-sdk-*.tar.gz --strip-components=1 -C $out

      patchShebangs $out
      autoPatchelf $out/bin

      unzip ${libffi_wasm32_src}
      cp include/*.h $out/share/wasi-sysroot/include
      cp lib/*.a $out/share/wasi-sysroot/lib/wasm32-wasi
    '';

    dontFixup = true;

    strictDeps = true;
  };

  wasm32_wasi_ghc = stdenvNoCC.mkDerivation {
    name = "wasm32-wasi-ghc";

    buildInputs = [ gmp ];
    nativeBuildInputs = [ autoPatchelfHook ];

    unpackPhase = ''
      cp -r ${wasm32_wasi_ghc_src} $out
      chmod -R u+w $out
      cd $out
    '';

    preConfigure = ''
      patchShebangs .
      autoPatchelf .

      configureFlagsArray+=(
        AR=${wasi_sdk}/bin/llvm-ar
        CC=${wasi_sdk}/bin/clang
        LD=${wasi_sdk}/bin/wasm-ld
        RANLIB=${wasi_sdk}/bin/llvm-ranlib
        STRIP=${wasi_sdk}/bin/llvm-strip
        CONF_CC_OPTS_STAGE2="-O3 -mmutable-globals -mnontrapping-fptoint -mreference-types -msign-ext"
        CONF_CXX_OPTS_STAGE2="-O3 -mmutable-globals -mnontrapping-fptoint -mreference-types -msign-ext"
        CONF_GCC_LINKER_OPTS_STAGE2="-Wl,--error-limit=0,--growable-table,--stack-first -Wno-unused-command-line-argument"
        --host=x86_64-linux
        --target=wasm32-wasi
      )
    '';

    buildPhase = ''
      make lib/settings
      ./bin/wasm32-wasi-ghc-pkg recache
    '';

    dontInstall = true;

    dontFixup = true;

    strictDeps = true;
  };
in
wasm32_wasi_ghc
