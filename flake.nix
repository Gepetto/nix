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

    # Ongoing development packages
    linear-feedback-controller-msgs = {
      url = "github:loco-3d/linear-feedback-controller-msgs/humble-devel";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    linear-feedback-controller = {
      url = "github:loco-3d/linear-feedback-controller/humble";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    franka-description = {
      url = "github:agimus-project/franka_description/humble-devel";
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
              #
              linear-feedback-controller = inputs.linear-feedback-controller.packages.${system}.linear-feedback-controller;
              #
              linear-feedback-controller-msgs = inputs.linear-feedback-controller-msgs.packages.${system}.linear-feedback-controller-msgs;
              #
              franka-description = inputs.franka-description.packages.${system}.franka-description;
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
        rosidlDir = "${pkgs.rosPackages.humble.rosidl-generator-cpp.outPath}/share/rosidl_generator_cpp/resource";
      in
      {
        devShells = {
          default = pkgs.mkShell {
            name = "Gepetto Main Dev Shell with NixGL";
            packages = [
              pkgs.eigen # Dependencies package for pinocchio and many package
              pkgs.octomap # from coal?
              pkgs.colcon # ROS2 super-builder
              pkgs.python3Packages.colcon-argcomplete # ROS2 super-builder argcomplete
              # Gazebo Ignition?
              # pkgs.gazebo
              #
              self.packages.${system}.python # Python packages see below
              self.packages.${system}.ros # ROS packages see below
            ];
            shellHook = ''
              export RMW_IMPLEMENTATION=rmw_fastrtps_cpp
              export CMAKE_PREFIX_PATH="$NIXPKGS_CMAKE_PREFIX_PATH:$CMAKE_PREFIX_PATH"

              # Enable colcon-argcomplete autocompletion
              activate-global-python-argcomplete
              source ${pkgs.python3Packages.colcon-argcomplete.outPath}/share/colcon_argcomplete/hook/colcon-argcomplete.bash

              # Enable ros to find idl template
              if [ -d "${rosidlDir}" ]; then
                export ROSIDL_TEMPLATES_PATH="${rosidlDir}"
              else
                echo "Error: ROSIDL templates directory not found!"
                return 1
              fi
            '';
          };
        };
        packages = {
          python = pkgs.python3.withPackages (p: [
            p.crocoddyl
            p.gepetto-gui
            p.hpp-corba
            p.mim-solvers
            pkgs.rosPackages.humble.xacro # Use the ROS package instead
          ]);
          ros =
            with pkgs.rosPackages.humble;
            buildEnv {
              paths = [
                ros-core
                # To use with linear-feedback-controller-msgs
                eigen3-cmake-module
                pkgs.linear-feedback-controller
                pkgs.linear-feedback-controller-msgs
                # Others
                rmw-fastrtps-cpp # Add both to choose dynamically
                rmw-cyclonedds-cpp # Add both to choose dynamically
                plotjuggler
                plotjuggler-ros
                pal-statistics
                pkgs.python3Packages.example-robot-data # for availability in AMENT_PREFIX_PATH
                pkgs.python3Packages.hpp-tutorial # for availability in AMENT_PREFIX_PATHl
                # Build ros msgs packages.
                rosidl-adapter
                rosidl-cli
                rosidl-cmake
                rosidl-default-generators
                rosidl-default-runtime
                rosidl-generator-c
                rosidl-generator-cpp
                rosidl-generator-dds-idl
                rosidl-generator-py
                rosidl-parser
                rosidl-runtime-c
                rosidl-runtime-cpp
                rosidl-runtime-py
                rosidl-typesupport-c
                rosidl-typesupport-cpp
                rosidl-typesupport-fastrtps-c
                rosidl-typesupport-fastrtps-cpp
                rosidl-typesupport-interface
                rosidl-typesupport-introspection-c
                rosidl-typesupport-introspection-cpp
                # Robot descriptions
                xacro
                # pkgs.franka-description
              ];
            };
        };
      }
    );
}
