{ autoPatchelfHook, lib, stdenvNoCC, unzip }:
let
  src = builtins.fetchurl {
    x86_64-linux =
      "https://nightly.link/bytecodealliance/wasmtime/workflows/main/main/bins-x86_64-linux.zip";
    aarch64-linux =
      "https://nightly.link/bytecodealliance/wasmtime/workflows/main/main/bins-aarch64-linux.zip";
    x86_64-darwin =
      "https://nightly.link/bytecodealliance/wasmtime/workflows/main/main/bins-x86_64-macos.zip";
  }.${stdenvNoCC.hostPlatform.system};
in
stdenvNoCC.mkDerivation {
  pname = "wasmtime";
  version = "dev";
  nativeBuildInputs = [ unzip ]
    ++ lib.optionals stdenvNoCC.isLinux [ autoPatchelfHook ];
  dontUnpack = true;
  installPhase = ''
    unzip ${src}
    for f in *.tar.xz; do
      tar xJf $f --strip-components=1
    done
    mkdir -p $out/bin
    install -Dm755 -t $out/bin wasmtime
  '';
  doInstallCheck = true;
  installCheckPhase = "$out/bin/wasmtime --version";
  strictDeps = true;
}
