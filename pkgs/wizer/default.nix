{ fetchFromGitHub, rustPlatform }:
rustPlatform.buildRustPackage rec {
  pname = "wizer";
  version = "1.3.5";
  src = fetchFromGitHub {
    owner = "bytecodealliance";
    repo = pname;
    rev = "15e739f9b6526132eb497b90b724d1ed3770e092";
    hash =
      "sha512-QMjaPyiboNQtrNVDoRyyLvBvBaklx+m/XsDwFsWCMk7jis7MYs/+HIInUJz5Fy7/OnRAInLiyj92ZdDjxvlZ6g==";
  };
  patches = [ ./wizer.diff ];
  cargoHash =
    "sha512-BnCnB9kLXc/S4LUpsP/zJsXQhNA/JmBaJnR/F0Q/Y4L2DsCY53pax1VDGevcmklgtOzR4fvkYWwvetMQmaOAkQ==";
  cargoBuildFlags = [ "--bin=wizer" "--features=env_logger,structopt" ];
  preCheck = "export HOME=$(mktemp -d)";
}
