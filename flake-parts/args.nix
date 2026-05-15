{
  inputs,
  ...
}:
{
  perSystem =
    {
      system,
      ...
    }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        overlays = [
          (_final: _prev: {
            niks3 = inputs.niks3.packages.${system}.niks3;
          })
        ];
      };
    };
}
