{ autoPatchelfHook, lib, stdenvNoCC, unzip }:
let
  src = builtins.fetchurl {
    x86_64-linux =
      "https://nightly.link/wasmerio/wasmer/workflows/build/master/wasmer-linux-amd64.zip";
    aarch64-linux =
      "https://nightly.link/wasmerio/wasmer/workflows/build/master/wasmer-linux-aarch64.tar.gz.zip";
    x86_64-darwin =
      "https://nightly.link/wasmerio/wasmer/workflows/build/master/wasmer-darwin-amd64.zip";
  }.${stdenvNoCC.hostPlatform.system};
in
stdenvNoCC.mkDerivation {
  pname = "wasmer";
  version = "master";
  nativeBuildInputs = [ unzip ]
    ++ lib.optionals stdenvNoCC.isLinux [ autoPatchelfHook ];
  dontUnpack = true;
  installPhase = ''
    unzip ${src}
    mkdir $out
    tar xzf wasmer.tar.gz -C $out
  '';
  doInstallCheck = true;
  installCheckPhase = "$out/bin/wasmer --version";
  strictDeps = true;
}
