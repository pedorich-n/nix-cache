{
  lib,
  writeShellApplication,
  gitMinimal,
  flyctl,
}:
{
  command ? "status",
  isDb ? false,
}:
let
  nameParts = [
    "fly"
    command
  ]
  ++ lib.optional isDb "db"
  ++ lib.optional (command == null) "wrapper";

  name = lib.concatStringsSep "-" nameParts;
in
writeShellApplication {
  inherit name;

  runtimeInputs = [
    gitMinimal
    flyctl
  ];

  text = ''
    ROOT="$(git rev-parse --show-toplevel)"

    workdir=${if isDb then "\${ROOT}/fly/db" else "\${ROOT}/fly"}
    cd "''${workdir}"

    if [ ! -f fly.toml ]; then
      echo "fly.toml not found in ''${workdir}, skipping deployment."
      exit 1
    fi

    fly ${command} "$@"
  '';
}
