{
  perSystem =
    {
      pkgs,
      lib,
      ...
    }:
    let
      packages = lib.filesystem.packagesFromDirectoryRecursive {
        inherit (pkgs) callPackage;
        directory = ../nix/apps;
      };

      apps = lib.mapAttrs (name: pkg: { program = pkg; }) packages;
    in
    {
      inherit apps;
    };
}
