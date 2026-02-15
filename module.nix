{ localFlake }:
{
  config,
  inputs,
  lib,
  ...
}:
{
  options.gepetto-pkgs = {
    overlays = lib.mkOption {
      default = [ ];
      description = "Additionnal overlays for nixpkgs";
    };
    patches = lib.mkOption {
      default = [ ];
      description = "Additionnal patches for nixpkgs";
    };
  };

  imports = [
    inputs.gazebros2nix.flakeModule
    {
      gazebros2nix-pkgs = {
        overlays = [
          (import ./overlay.nix { inherit (localFlake) inputs; })
        ]
        ++ config.gepetto-pkgs.overlays;
        patches =
          lib.fileset.toList (lib.fileset.maybeMissing ./patches/NixOS/nixpkgs)
          ++ config.gepetto-pkgs.patches;
      };
    }
  ];
}
