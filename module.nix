{
  config,
  inputs,
  lib,
  self,
  ...
}:
let
  cfg = config.gepetto-pkgs;
in
{
  options.gepetto-pkgs = {
    pkgs = lib.mkOption {
      type = lib.types.bool;
      description = "define pkgs from nixpkgs with overlays from nix-ros-overlay, gazebros2nix, gepetto-pkgs, and overlays";
      default = true;
    };
  };

  imports = [
    inputs.gazebros2nix.flakeModule
    {
      gazebros2nix.pkgs = false;
    }
  ];

  config = {
    flake.overlays.gepetto-pkgs = import ./overlay.nix { inherit lib; };

    perSystem =
      { system, ... }:
      lib.optionalAttrs cfg.pkgs {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          config = config.flakoboros.nixpkgsConfig;
          overlays = [
            inputs.nix-ros-overlay.overlays.default
            self.overlays.gazebros2nix
            self.overlays.gepetto-pkgs
            self.overlays.flakoboros
          ]
          ++ config.flakoboros.overlays;
        };
      };
  };
}
