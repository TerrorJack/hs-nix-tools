{ fetchFromGitHub, rustPlatform }:
rustPlatform.buildRustPackage rec {
  pname = "wizer";
  version = "1.3.5";
  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = pname;
    rev = "42640a277d605b90c8b93e82786b1ea564b600a7";
    hash =
      "sha512-dRsmbiO+ZhQVX7hVr/mYvxJ5nux5xKfjW2jfgyRzjx0yoEvzTfZ8z84fYcCbrG4BrpdbmoZnYpb9gSHwxVq2JQ==";
  };
  patches = [ ./37.diff ];
  cargoHash =
    "sha512-7ntHJHeZ3rAbu1oS/92acmrEh5+avD3+uAFE/fim6rEDepSKkRtbFTNvqSQ4y2kjSkde9ylcDiXt2ihwrqlgcQ==";
  cargoBuildFlags = [ "--bin=wizer" "--features=env_logger,structopt" ];
  preCheck = "export HOME=$(mktemp -d)";
}
