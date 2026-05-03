{
  perSystem =
    {
      pkgs,
      lib,
      ...
    }:
    let
      mkFlyWrapper = args: pkgs.callPackage (import ../nix/lib/mk-fly-command.nix args) { };
      mkTofuWrapper = args: pkgs.callPackage (import ../nix/lib/mk-tofu-command.nix args) { };

      packages = lib.filesystem.packagesFromDirectoryRecursive {
        callPackage = lib.callPackageWith (pkgs // { inherit mkFlyWrapper mkTofuWrapper; });
        directory = ../nix/apps;
      };

      apps = lib.mapAttrs (name: pkg: { program = pkg; }) packages;
    in
    {
      inherit apps;
    };
}
