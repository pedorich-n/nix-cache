{
  perSystem =
    {
      pkgs,
      lib,
      ...
    }:
    let
      mkFlyWrapper = args: pkgs.callPackage (import ../nix/lib/mk-fly-command.nix args) { };

      packages = lib.filesystem.packagesFromDirectoryRecursive {
        callPackage = lib.callPackageWith (pkgs // { inherit mkFlyWrapper; });
        directory = ../nix/apps;
      };

      apps = lib.mapAttrs (name: pkg: { program = pkg; }) packages;
    in
    {
      inherit apps;
    };
}
