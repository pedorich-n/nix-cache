{
  perSystem =
    {
      pkgs,
      lib,
      ...
    }:
    let
      wrappers = lib.filesystem.packagesFromDirectoryRecursive {
        inherit (pkgs) callPackage;
        directory = ../nix/wrappers;
      };

      packages = lib.filesystem.packagesFromDirectoryRecursive {
        callPackage = lib.callPackageWith (pkgs // { inherit wrappers; });
        directory = ../nix/apps;
      };

      apps = lib.mapAttrs (_name: pkg: { program = pkg; }) packages;
    in
    {
      inherit apps;
    };
}
