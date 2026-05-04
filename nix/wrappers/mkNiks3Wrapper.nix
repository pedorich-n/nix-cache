{
  writeShellApplication,
  gitMinimal,
  niks3,
}:
{
  command ? "gc",
}:
writeShellApplication {
  name = "niks3-${command}-wrapper";

  runtimeInputs = [
    gitMinimal
    niks3
  ];

  text = ''
    ROOT="$(git rev-parse --show-toplevel)"

    get_tf_output() {
      cd "''${ROOT}/terraform"
      tofu output -raw "$1" 2>/dev/null || echo ""
    }

    ensure_envs() {
      for var in "$@"; do
        if [[ -z "''${!var}" ]]; then
          echo "Error: required environment variable '$var' is not set" >&2
          exit 1
        fi
      done
    }

    if [ "''${CI:-false}" = "false" ]; then
      NIKS3_API_TOKEN=$(get_tf_output niks3_api_token)
      NIKS3_SERVER_URL=$(get_tf_output fly_app_url)
    else
      ensure_envs "NIKS3_API_TOKEN" "NIKS3_SERVER_URL"
    fi

    niks3 ${command} \
      --server-url "''${NIKS3_SERVER_URL}" \
      --auth-token "''${NIKS3_API_TOKEN}" \
      "$@"
  '';
}
