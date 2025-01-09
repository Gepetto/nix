{
  inputs = {
    nix-ros-overlay.url = "github:lopsided98/nix-ros-overlay/develop";
    nixpkgs.follows = "nix-ros-overlay/nixpkgs";

    ## Patches for nixpkgs
    # init HPP v6.0.0
    # also: hpp-fcl v2.4.5 -> coal v3.0.0
    patch-hpp = {
      url = "https://github.com/nim65s/nixpkgs/pull/2.patch";
      flake = false;
    };

    # hpp-tutorial needs PR2 robot in example-robot-data
    # which is available in >= 4.2.0, which landed in master but not yet on nix-ros
    patch-example-robot-data = {
      url = "https://github.com/NixOS/nixpkgs/pull/363802.patch";
      flake = false;
    };

    # gepetto-viewer has a fix to understand AMENT_PREFIX_PATH in #239/devel
    gepetto-viewer = {
      url = "github:Gepetto/gepetto-viewer/devel";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
            (_super: prev: {
              gepetto-viewer = prev.gepetto-viewer.overrideAttrs {
                inherit (inputs.gepetto-viewer.packages.${system}.gepetto-viewer) src;
              };
            })
            (_super: prev: {
              # Override protobuf version to ensure compatibility with plotjuggler.
              protobuf = prev.protobuf3_21;
            })
          ];
          patches = [
            inputs.patch-example-robot-data
            inputs.patch-hpp
          ];
        };
        pure-packages = [
          pkgs.colcon
          self.packages.${system}.python
          self.packages.${system}.ros
        ];
        # Precompute the BASE_DIR path
        baseDir = pkgs.python3Packages.example-robot-data.outPath;
        # Define the shared shell hook, referencing the precomputed path
        sharedShellHook = ''
          if [ -z "$BASE_DIR" ]; then
            echo "Error: Could not locate the example-robot-data package." >&2
          else
            SHARE_DIR=$BASE_DIR
            export AMENT_PREFIX_PATH=$SHARE_DIR:$AMENT_PREFIX_PATH
            export ROS_PACKAGE_PATH=$SHARE_DIR/share:$ROS_PACKAGE_PATH
            echo "Added $SHARE_DIR to AMENT_PREFIX_PATH and ROS_PACKAGE_PATH"
          fi
        '';
      in
      {
        devShells = {
          default = pkgs.mkShell {
            name = "Gepetto Main Dev Shell with NixGL";
            packages = pure-packages ++ [
              self.packages.${system}.nixgl-gepetto-gui
            ];
          };
          pure = pkgs.mkShell {
            name = "Gepetto Main Dev Shell";
            packages = pure-packages;
            shellHook = ''
              export BASE_DIR='${baseDir}'
              ${sharedShellHook}
            '';
          };
        };
        packages = {
          python = pkgs.python3.withPackages (p: [
            p.crocoddyl
            p.gepetto-gui
            p.hpp-corba
          ]);
          ros =
            with pkgs.rosPackages.humble;
            buildEnv {
              paths = [
                ros-core
                rmw-fastrtps-cpp
                rmw-cyclonedds-cpp
                plotjuggler
                plotjuggler-ros
                pkgs.python3Packages.example-robot-data # for availability in AMENT_PREFIX_PATH
                pkgs.python3Packages.hpp-tutorial # for availability in AMENT_PREFIX_PATH
              ];
            };
        };
      }
    );
}
