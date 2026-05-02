{
  writeShellApplication,
  gitMinimal,
  jq,
  flyctl,
  opentofu,
}:
writeShellApplication {
  name = "fly-setup-postgres";

  runtimeInputs = [
    gitMinimal
    jq
    flyctl
    opentofu
  ];

  text = ''
    ROOT="$(git rev-parse --show-toplevel)"

    get_tf_output() {
      cd "''${ROOT}/terraform"
      tofu output -raw "$1" 2>/dev/null || echo ""
    }

    FLY_APP_NAME=$(get_tf_output fly_app_name)
    DB_NAME="''${FLY_APP_NAME}-db"

    existing=$(fly postgres list --json 2>/dev/null | jq -r '.[].ID // empty')

    if echo "$existing" | grep -qx "''${DB_NAME}"; then
      echo "Postgres cluster ''${DB_NAME}' already exists, skipping creation."
      exit 0
    fi

    fly postgres create \
      --name "''${DB_NAME}" \
      --region nrt \
      --vm-size shared-cpu-1x \
      --initial-cluster-size 1 \
      --volume-size 1
  '';
}
