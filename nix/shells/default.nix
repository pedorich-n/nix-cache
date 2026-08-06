{
  mkShellNoCC,
  bashInteractive,
  flyctl,
  gitMinimal,
  niks3,
  opentofu,
}:
mkShellNoCC {
  name = "tf";

  buildInputs = [
    bashInteractive
    flyctl
    gitMinimal
    niks3
    opentofu
  ];

  shellHook = ''
    ROOT="$(git rev-parse --show-toplevel)"

    if ! [ -x "$(command -v op)" ]; then
      echo "Error: 1Password CLI (op) not found in PATH!" >&2
      exit 1
    fi

    if ! [ -x "$(command -v gh)" ]; then
      echo "Error: GitHub CLI (gh) not found in PATH!" >&2
      exit 1
    fi

    OP_ACCOUNT=$(op account list --format=json | jq -r '.[0] | .account_uuid')
    export OP_ACCOUNT

    GH_PATH="$(which gh)"
    export GH_PATH

    fly status --config "''${ROOT}/fly/fly.toml"
  '';
}
