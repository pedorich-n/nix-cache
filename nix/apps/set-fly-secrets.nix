{
  writeShellApplication,
  gitMinimal,
  flyctl,
  opentofu,
}:
writeShellApplication {
  name = "set-fly-secrets";

  runtimeInputs = [
    gitMinimal
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
    R2_ENDPOINT=$(get_tf_output r2_endpoint)
    R2_BUCKET_REGION=$(get_tf_output r2_bucket_region)
    R2_BUCKET_NAME=$(get_tf_output r2_bucket_name)
    R2_BUCKET_ACCESS_KEY_ID=$(get_tf_output r2_bucket_access_key_id)
    R2_BUCKET_ACCESS_KEY_SECRET=$(get_tf_output r2_bucket_access_key_secret)
    NIX_SIGNING_KEY_BASE64=$(get_tf_output nix_signing_key_base64)
    NIKS3_API_TOKEN=$(get_tf_output niks3_api_token)
    NIKS3_OIDC_CONFIG_BASE64=$(get_tf_output niks3_oidc_json_base64)

    echo "Setting Fly secrets for app ''${FLY_APP_NAME}..."
    fly secrets set --app "''${FLY_APP_NAME}" \
      NIKS3_S3_ENDPOINT="''${R2_ENDPOINT}" \
      NIKS3_S3_BUCKET="''${R2_BUCKET_NAME}" \
      NIKS3_S3_ACCESS_KEY="''${R2_BUCKET_ACCESS_KEY_ID}" \
      NIKS3_S3_SECRET_KEY="''${R2_BUCKET_ACCESS_KEY_SECRET}" \
      NIKS3_S3_REGION="''${R2_BUCKET_REGION}" \
      NIKS3_API_TOKEN="''${NIKS3_API_TOKEN}" \
      NIX_SIGNING_KEY_BASE64="''${NIX_SIGNING_KEY_BASE64}" \
      NIKS3_OIDC_CONFIG_BASE64="''${NIKS3_OIDC_CONFIG_BASE64}"
  '';
}
