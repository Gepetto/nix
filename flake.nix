{
  inputs = {
    ## TODO: this is the expected use
    # we can't do that for now, and therefore we are loosing ros.cachix.org
    #nix-ros-overlay.url = "github:lopsided98/nix-ros-overlay/master";
    #nixpkgs.follows = "nix-ros-overlay/nixpkgs"; # IMPORTANT!!!

    # ref. https://github.com/lopsided98/nix-ros-overlay/pull/538: ros pinocchio is nixpkgs pinocchio
    nix-ros-overlay = {
      url = "github:nim65s/nix-ros-overlay/pin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nix-ros-overlay.inputs.nixpkgs is too old for now,
    # patching packages which were moved to by-name is tedious,
    # so let's switch to upstream for now.
    # We'll have to compile / cache ROS stuff we need to gepetto.cachix.org for now.
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    ## Patches for nixpkgs
    # init HPP v6.0.0
    # also: hpp-fcl v2.4.5 -> coal v3.0.0
    patch-hpp = {
      url = "https://github.com/NixOS/nixpkgs/pull/362956.patch";
      flake = false;
    };

    ## NixGL, for people not yet on NixOS
    nixgl.url = "github:nix-community/nixGL";
  };
  outputs =
    { nixpkgs, self, ... }@inputs:
    inputs.nix-ros-overlay.inputs.flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import ./patched-nixpkgs.nix {
          inherit nixpkgs system;
          overlays = [
            inputs.nix-ros-overlay.overlays.default
            inputs.nixgl.overlay
          ];
          patches = [
            inputs.patch-hpp
          ];
        };
      in
      {
        devShells = {
          # Expected base entrypoint.
          # This is "pure" + some stuff wrapped by NixGL
          default = pkgs.mkShell {
            name = "Gepetto Main Dev Shell with NixGL";
            packages = [
              pkgs.colcon
              self.packages.${system}.nixgl-gepetto-gui
              self.packages.${system}.python
              self.packages.${system}.ros
            ];
          };
          pure = pkgs.mkShell {
            name = "Gepetto Main Dev Shell";
            packages = [
              pkgs.colcon
              self.packages.${system}.python
              self.packages.${system}.ros
            ];
          };
        };
        packages = {
          nixgl-gepetto-gui =
            with pkgs;
            writeShellApplication {
              name = "nixgl-gepetto-gui";
              text = "${lib.getExe' nixgl.auto.nixGLDefault "nixGL"} ${lib.getExe python3Packages.gepetto-gui}";
            };
          python = pkgs.python3.withPackages (p: [
            p.example-robot-data
            p.gepetto-gui
            p.hpp
          ]);
          ros =
            with pkgs.rosPackages.humble;
            buildEnv {
              paths = [
                ros-core
                turtlesim
              ];
            };
        };
      }
    );
}
