{ autoPatchelfHook, fetchzip, lib, stdenv }:
stdenv.mkDerivation rec {
  pname = "wasmtime";
  version = "0.35.2";
  src = fetchzip {
    x86_64-linux = {
      url =
        "https://github.com/bytecodealliance/wasmtime/releases/download/v${version}/wasmtime-v${version}-x86_64-linux.tar.xz";
      hash =
        "sha512-M9sWDGTti91VRFq23Uo7pFyNYZdPrLLl5l3wBFy3LqTzLEwCwaCSNFDS9obiV4FSDO3Vr9b6w1NfGrkpW5Aqpw==";
    };
    aarch64-linux = {
      url =
        "https://github.com/bytecodealliance/wasmtime/releases/download/v${version}/wasmtime-v${version}-aarch64-linux.tar.xz";
      hash =
        "sha512-1lUt0COgeXAU1xbafOf+3Nj8O9pSCKRXClT9pVMrnG7PkRbOFLU8fazLH63zoxTdXueNqtRzAjaF/d6lFH3/3g==";
    };
    x86_64-darwin = {
      url =
        "https://github.com/bytecodealliance/wasmtime/releases/download/v${version}/wasmtime-v${version}-x86_64-macos.tar.xz";
      hash =
        "sha512-EpLXcs7DYEECM+sBBbTM5IFBUWbrSm3pCDcvjkgguuEla5EC5yPcFGrn4yYep/BPQ1pIzmJubtSIqFdC4Tm/kw==";
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
