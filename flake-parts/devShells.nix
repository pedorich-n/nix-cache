{
  perSystem =
    {
      pkgs,
      lib,
      ...
    }:
    {
      devShells = lib.filesystem.packagesFromDirectoryRecursive {
        inherit (pkgs) callPackage;
        directory = ../nix/shells;
      };
    };
}
