{ autoPatchelfHook, fetchzip, lib, stdenv }:
stdenv.mkDerivation rec {
  pname = "wasmtime";
  version = "0.34.0";
  src = fetchzip {
    x86_64-linux = {
      url =
        "https://github.com/bytecodealliance/wasmtime/releases/download/v${version}/wasmtime-v${version}-x86_64-linux.tar.xz";
      hash =
        "sha512-nSRREqwAXvCabvCoL+BmGIU0B9k0H+BRxKLLvnZJvXyNmmwt3B2Gs3sld4f6DDUePrya54FexwtF9/F10yw+1w==";
    };
    aarch64-linux = {
      url =
        "https://github.com/bytecodealliance/wasmtime/releases/download/v${version}/wasmtime-v${version}-aarch64-linux.tar.xz";
      hash =
        "sha512-wlCFS/EjkqDterc7E/n4wYO5Gs8EdjvKFoPjXaiebWkAdLdAy97l1/isHRyM1LchVeldNwngEpfrr3hFK3We9g==";
    };
    x86_64-darwin = {
      url =
        "https://github.com/bytecodealliance/wasmtime/releases/download/v${version}/wasmtime-v${version}-x86_64-macos.tar.xz";
      hash =
        "sha512-l/3CHFUrOz84KHWtjywuXWW8ZG1xAdyD9mq7yjnDITAyx+ir3nMwbFeYIyhX1AEc+NHYOga5GoyzDOpoX0BqCQ==";
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
