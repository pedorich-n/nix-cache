{
  command ? null,
}:
{
  lib,
  writeShellApplication,
  gitMinimal,
  opentofu,
}:
let
  nameParts = [
    "tofu"
  ]
  ++ lib.optional (command != null) command
  ++ lib.optional (command == null) "wrapper";

  name = lib.concatStringsSep "-" nameParts;
in
writeShellApplication {
  inherit name;

  runtimeInputs = [
    gitMinimal
    opentofu
  ];

  text = ''
    ROOT="$(git rev-parse --show-toplevel)"

    if ! [ -x "$(command -v op)" ]; then
      echo "Error: 1Password CLI (op) not found in PATH!" >&2
      exit 1
    fi


    OP_ACCOUNT=$(op account list --format=json | jq -r '.[0] | .account_uuid')
    export OP_ACCOUNT

    cd "''${ROOT}/terraform"

    ${lib.optionalString (command != null) "tofu ${command}"}
    ${lib.optionalString (command == null) "tofu validate"}
  '';
}
