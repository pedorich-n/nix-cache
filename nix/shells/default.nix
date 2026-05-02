{
  mkShellNoCC,
  flyctl,
  gitMinimal,
  opentofu,
}:
mkShellNoCC {
  name = "tf";

  buildInputs = [
    gitMinimal
    flyctl
    opentofu
  ];

  shellHook = ''
    ROOT="$(git rev-parse --show-toplevel)"

    if ! [ -x "$(command -v op)" ]; then
      echo "Error: 1Password CLI (op) not found in PATH!" >&2
      exit 1
    fi


    OP_ACCOUNT=$(op account list --format=json | jq -r '.[0] | .user_uuid')
    export OP_ACCOUNT

    cd "$ROOT/fly" && fly status
  '';
}
