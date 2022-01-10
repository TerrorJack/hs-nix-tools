{ fetchFromGitHub, rustPlatform }:
rustPlatform.buildRustPackage rec {
  pname = "wizer";
  version = "1.3.5";
  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = pname;
    rev = "5dbfd4eade422acdff4c019941addf2656213df7";
    hash =
      "sha512-8s4oMJRSFxosyPrlsjKjpnSroYpFdF70RjaCJYAcGOvM39diEMleEpeqLA5JiTJQmKce8ShRa5VjbD5vDPjSvg==";
  };
  patches = [ ./37.diff ];
  cargoHash =
    "sha512-7ntHJHeZ3rAbu1oS/92acmrEh5+avD3+uAFE/fim6rEDepSKkRtbFTNvqSQ4y2kjSkde9ylcDiXt2ihwrqlgcQ==";
  cargoBuildFlags = [ "--bin=wizer" "--features=env_logger,structopt" ];
  preCheck = "export HOME=$(mktemp -d)";
}
