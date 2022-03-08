{ autoPatchelfHook, fetchzip, lib, stdenv }:
stdenv.mkDerivation rec {
  pname = "wasmtime";
  version = "0.34.1";
  src = fetchzip {
    x86_64-linux = {
      url =
        "https://github.com/bytecodealliance/wasmtime/releases/download/v${version}/wasmtime-v${version}-x86_64-linux.tar.xz";
      hash =
        "sha512-ke1zw2xcviwn7d7OnHgPRyHackl6k7/6gEOdeq/kvplgwja8dGWjQp5Hoo02AHCJlr6WiFF/poQ73heUHTlCeg==";
    };
    aarch64-linux = {
      url =
        "https://github.com/bytecodealliance/wasmtime/releases/download/v${version}/wasmtime-v${version}-aarch64-linux.tar.xz";
      hash =
        "sha512-tFHV4oF1iMpofTy44p/kxMQSBPCM0b9tc3La5URE260bi5B6vWe+WKJmWHNaonHVesvyOKQkvM2JlByINvRO8Q==";
    };
    x86_64-darwin = {
      url =
        "https://github.com/bytecodealliance/wasmtime/releases/download/v${version}/wasmtime-v${version}-x86_64-macos.tar.xz";
      hash =
        "sha512-RGTu7DsFzPqIsQcTt5a+2D/fr7gBmYI6Sq+66xzQZtwzC2dRqhmhlX4U/RIeQgMSyNaYa0V692eU8bHFaPuBUg==";
    };
  }.${stdenv.hostPlatform.system};
  nativeBuildInputs = lib.optionals stdenv.isLinux [ autoPatchelfHook ];
  installPhase = ''
    mkdir -p $out/bin
    install -Dm755 -t $out/bin wasmtime
  '';
  doInstallCheck = true;
  installCheckPhase = "$out/bin/wasmtime --version";
  strictDeps = true;
}
