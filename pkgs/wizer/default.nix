{ pkgsStatic }:
pkgsStatic.callPackage
  ({ fetchFromGitHub, rustPlatform }:
    rustPlatform.buildRustPackage rec {
      pname = "wizer";
      version = "1.3.5";
      src = fetchFromGitHub {
        owner = "bytecodealliance";
        repo = pname;
        rev = "1802237aeb8c19ff9448d67d280935bc10110d32";
        hash =
          "sha512-qc36Tb/7r2ZtL2T3pYCO7sBxENJQOWMDySftgbFq52SWdVqGYaHsBDXOk7IEm2rN/IjuIqKxTZJR3kmQbWXB7w==";
      };
      patches = [ ./37.diff ];
      cargoHash =
        "sha512-7ntHJHeZ3rAbu1oS/92acmrEh5+avD3+uAFE/fim6rEDepSKkRtbFTNvqSQ4y2kjSkde9ylcDiXt2ihwrqlgcQ==";
      cargoBuildFlags = [ "--bin=wizer" "--features=env_logger,structopt" ];
      preCheck = "export HOME=$(mktemp -d)";
      allowedReferences = [ ];
    })
{ }
