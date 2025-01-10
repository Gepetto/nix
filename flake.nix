{
  inputs = {
    nix-ros-overlay.url = "github:lopsided98/nix-ros-overlay/develop";
    nixpkgs.follows = "nix-ros-overlay/nixpkgs";

    # nix-gazebo-sim-overlay.url = "github:muellerbernd/gazebo-sim-overlay/main";

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
            # inputs.nix-gazebo-sim-overlay.overlays.default
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
        # Precompute the BASE_DIR path
        baseDir = pkgs.python3Packages.example-robot-data.outPath;
        rosDir = self.packages.${system}.ros.outPath;
        # Define the shared shell hook, referencing the precomputed path
        sharedShellHook = ''

        '';
      in
      {
        devShells = {
          default = pkgs.mkShell {
            name = "Gepetto Main Dev Shell with NixGL";
            packages = [
              pkgs.eigen # Dependencies package for pinocchio and many package
              pkgs.octomap # from coal?
              pkgs.colcon # ROS2 super-builder
              # Gazebo Ignition?
              # pkgs.gazebo
              #
              self.packages.${system}.python # Python packages see below
              self.packages.${system}.ros # ROS packages see below
            ];
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
                # linear-feedback-controller-msgs dependencies
                ament-cmake-core
                eigen3-cmake-module
                tf2-eigen
                python-cmake-module
                # linear-feedback-controller dependencies
                urdfdom
                urdfdom-headers
                generate-parameter-library
                ros2-control
                control-toolbox
                # Others
                rmw-fastrtps-cpp
                plotjuggler
                plotjuggler-ros
                pal-statistics
                pkgs.python3Packages.example-robot-data # for availability in AMENT_PREFIX_PATH
                pkgs.python3Packages.hpp-tutorial # for availability in AMENT_PREFIX_PATH
              ];
            };
        };
      }
    );
}
