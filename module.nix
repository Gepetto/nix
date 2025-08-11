{ localFlake }:
{
  config,
  inputs,
  lib,
  ...
}:
{
  imports = [ inputs.treefmt-nix.flakeModule ];

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

  config = {
    perSystem =
      { self', system, ... }:
      {
        _module.args.pkgs =
          let
            pkgsForPatching = inputs.nixpkgs.legacyPackages.${system};
            patchedNixpkgs = (
              pkgsForPatching.applyPatches {
                name = "gepetto patched nixpkgs";
                src = inputs.nixpkgs;
                patches = lib.fileset.toList ./patches/NixOS/nixpkgs ++ config.gepetto-pkgs.patches;
              }
            );
          in
          import patchedNixpkgs {
            inherit system;
            config.allowUnfree = true;
            config.permittedInsecurePackages = [
              # SHAME
              "freeimage-3.18.0-unstable-2024-04-18"
            ];
            overlays = [
              inputs.nix-ros-overlay.overlays.default
              inputs.gazebo-sim-overlay.overlays.default
              (import ./overlay.nix { inherit (localFlake) inputs; })
            ] ++ config.gepetto-pkgs.overlays;
          };
        checks =
          let
            devShells = lib.mapAttrs' (n: lib.nameValuePair "devShell-${n}") self'.devShells;
            packages = lib.mapAttrs' (n: lib.nameValuePair "package-${n}") self'.packages;
          in
          lib.filterAttrs (_n: v: v.meta.available && !v.meta.broken) (devShells // packages);
        treefmt = {
          # workaround  https://github.com/numtide/treefmt-nix/issues/352
          pkgs = inputs.nixpkgs.legacyPackages.${system};
          programs = {
            deadnix.enable = true;
            keep-sorted.enable = true;
            nixfmt.enable = true;
          };
        };
      };
  };
}
