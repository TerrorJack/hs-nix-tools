{ autoPatchelfHook, fetchzip, lib, stdenv }:
stdenv.mkDerivation rec {
  pname = "wasmtime";
  version = "0.35.3";
  src = fetchzip {
    x86_64-linux = {
      url =
        "https://github.com/bytecodealliance/wasmtime/releases/download/v${version}/wasmtime-v${version}-x86_64-linux.tar.xz";
      hash =
        "sha512-JiBn3YXxBUb/c8Iz83H+3xM8mu8akpVm/POE5BDcFMBTMi3xkXDlfPNGEypR5xs00CphUKHhpUfXJ1ac81vAJQ==";
    };
    aarch64-linux = {
      url =
        "https://github.com/bytecodealliance/wasmtime/releases/download/v${version}/wasmtime-v${version}-aarch64-linux.tar.xz";
      hash =
        "sha512-x5lB9QT54WUPuqKUjRbq5NKAyHPsjsoTCzNYz9QUWhQvRB/h8UkRC3vFfePrx4vrqhCDjySNXmM8xJcuTbDr5A==";
    };
    x86_64-darwin = {
      url =
        "https://github.com/bytecodealliance/wasmtime/releases/download/v${version}/wasmtime-v${version}-x86_64-macos.tar.xz";
      hash =
        "sha512-S6G6tOlGW6pCQMIMDKimoLHfQXpVguY7B7SV+JnzgbzXIFuWFl+1xigj2bgRBDaIGKyNEaQin2xJuUqfA4Wq4A==";
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
