{
  inputs = {
    self.submodules = true;

    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";

    niks3 = {
      url = "github:Mic92/niks3";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, systems, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { lib, ... }:
      {
        systems = import systems;

        debug = true;

        imports = lib.filesystem.listFilesRecursive ./flake-parts;
      }
    );
}
