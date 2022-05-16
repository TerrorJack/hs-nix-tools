{ autoPatchelfHook, gcc9Stdenv, gmp, libxml2, ncurses, stdenvNoCC, unzip }:
let
  wasi_sdk_src = builtins.fetchurl
    "https://nightly.link/WebAssembly/wasi-sdk/workflows/main/main/dist-ubuntu-latest.zip";
  libffi_wasm32_src = builtins.fetchurl
    "https://nightly.link/tweag/libffi-wasm32/workflows/shell/master/out.zip";

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
in
wasi_sdk
