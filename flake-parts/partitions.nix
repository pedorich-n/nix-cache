{
  inputs,
  ...
}:
{
  imports = [
    inputs.flake-parts.flakeModules.partitions
  ];

  partitions.dev = {
    extraInputsFlake = ../dev;
    module = {
      imports = [
        ../dev/flake-module.nix
      ];

      perSystem = {
        treefmt.config = {
          projectRoot = ../.;

          settings = {
            global.excludes = [
              "**/.terraform.lock.hcl"
            ];
          };

          programs = {
            terraform = {
              enable = true;
            };
          };
        };
      };
    };
  };

  partitionedAttrs = {
    devShells = "dev";
    checks = "dev";
    formatter = "dev";
  };
}
