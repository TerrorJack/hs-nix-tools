{ autoPatchelfHook, fetchzip, lib, stdenv }:
stdenv.mkDerivation rec {
  pname = "wasmtime";
  version = "0.33.0";
  src = fetchzip {
    x86_64-linux = {
      url =
        "https://github.com/bytecodealliance/wasmtime/releases/download/v${version}/wasmtime-v${version}-x86_64-linux.tar.xz";
      hash =
        "sha512-EVDX2G3BP/Wp5ivtdEldlXtOYZPHkwiu29iKvKacPKr1dxJJcl5iHBuS18JJ6Kz2RRxD+ShUfOoVxh7f9NEN6Q==";
    };
    aarch64-linux = {
      url =
        "https://github.com/bytecodealliance/wasmtime/releases/download/v${version}/wasmtime-v${version}-aarch64-linux.tar.xz";
      hash =
        "sha512-EVnl9bCqD2Kl5tE1G42D8DNN4hiUnIOstET2gGc6saIeYsYqyuylBw6K/O2ayAU1tKL04QcnOQ2HgxmuXCWRig==";
    };
    x86_64-darwin = {
      url =
        "https://github.com/bytecodealliance/wasmtime/releases/download/v${version}/wasmtime-v${version}-x86_64-macos.tar.xz";
      hash =
        "sha512-kynqOHfA6RcZXD2kWJ6iXBe02jO63OMDcWIyUn1h00yXDFxhUgawjAp+2nW5GTg1Qq2gNgD/5Yrr0mVgk4Ko8Q==";
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
