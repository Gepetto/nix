{
  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nix-ros-overlay.url = "github:lopsided98/nix-ros-overlay/develop";
    nix-system-graphics = {
      url = "github:soupglasses/nix-system-graphics";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.follows = "nix-ros-overlay/nixpkgs";
    system-manager = {
      url = "github:numtide/system-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    systems.follows = "nix-ros-overlay/flake-utils/systems";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # keep-sorted start block=yes

    src-agimus-controller = {
      url = "github:agimus-project/agimus_controller";
      flake = false;
    };
    src-agimus-msgs = {
      url = "github:agimus-project/agimus_msgs";
      flake = false;
    };
    src-colmpc = {
      url = "github:agimus-project/colmpc";
      flake = false;
    };
    src-example-parallel-robots = {
      url = "github:gepetto/example-parallel-robots";
      flake = false;
    };
    src-franka-description = {
      url = "github:agimus-project/franka_description";
      flake = false;
    };
    # gepetto-viewer has a fix to understand AMENT_PREFIX_PATH in #239/devel
    src-gepetto-viewer = {
      url = "github:Gepetto/gepetto-viewer/devel";
      flake = false;
    };
    src-odri-control-interface = {
      # TODO url = "github:open-dynamic-robot-initiative/odri_control_interface"; see https://github.com/open-dynamic-robot-initiative/odri_control_interface/pull/26
      url = "github:gwennlbh/odri_control_interface/nix";
      flake = false;
    };
    src-odri-masterboard-sdk = {
      url = "github:gwennlbh/master-board/nix";
      flake = false;
      # TODO: sparse checkout
    };
    src-toolbox-parallel-robots = {
      url = "github:gepetto/toolbox-parallel-robots";
      flake = false;
    };

    # keep-sorted end
  };
  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      { self, lib, ... }:
      let
        flakeModule = inputs.flake-parts.lib.importApply ./module.nix { localFlake = self; };
      in
      {
        systems = import inputs.systems;
        imports = [ flakeModule ];
        flake = {
          inherit flakeModule;
          systemConfigs.default = inputs.system-manager.lib.makeSystemConfig {
            modules = [
              inputs.nix-system-graphics.systemModules.default
              {
                config = {
                  nixpkgs.hostPlatform = "x86_64-linux";
                  system-graphics.enable = true;
                };
              }
            ];
          };
          templates.default = {
            path = ./template;
            description = "A template for use with gepetto/nix";
          };
        };
        perSystem =
          {
            inputs',
            pkgs,
            self',
            system,
            ...
          }:
          {

            devShells = {
              default = pkgs.mkShell {
                name = "Gepetto Main Dev Shell";
                packages = [
                  # keep-sorted start
                  pkgs.colcon
                  self'.packages.python
                  self'.packages.ros
                  # keep-sorted end
                ];
              };
              gs = pkgs.mkShell {
                name = "Dev Shell for Guilhem";
                packages = [
                  (pkgs.rosPackages.jazzy.python3.withPackages (p: [
                    p.bloom
                    p.rosdep
                  ]))
                ];
              };
              ms = pkgs.mkShell {
                name = "Dev Shell for Maxime";
                inputsFrom = [ pkgs.python3Packages.crocoddyl ];
                packages = [
                  (pkgs.python3.withPackages (p: [
                    # keep-sorted start
                    p.example-parallel-robots
                    p.fatrop
                    p.gepetto-gui
                    p.ipython
                    p.matplotlib
                    p.mim-solvers
                    p.opencv4
                    p.pandas
                    p.proxsuite
                    p.quadprog
                    p.scikit-learn
                    p.seaborn
                    # keep-sorted end
                  ]))
                ];
                shellHook = ''
                  export PYTHONPATH=${
                    lib.concatStringsSep ":" [
                      "$PWD/src/cobotmpc"
                      "$PWD/install/${pkgs.python3.sitePackages}"
                      "$PYTHONPATH"
                    ]
                  }
                '';
              };
            };
            packages = lib.filterAttrs (_n: v: v.meta.available && !v.meta.broken) (
              {
                python = pkgs.python3.withPackages (p: [
                  # keep-sorted start
                  p.agimus-controller
                  p.agimus-controller-examples
                  p.crocoddyl
                  p.gepetto-gui
                  p.hpp-corba
                  p.ipython
                  p.matplotlib
                  # keep-sorted end
                ]);
                ros =
                  with pkgs.rosPackages.humble;
                  buildEnv {
                    paths = [
                      # keep-sorted start
                      pkgs.python3Packages.example-robot-data # for availability in AMENT_PREFIX_PATH
                      pkgs.python3Packages.hpp-tutorial # for availability in AMENT_PREFIX_PATH
                      ros-core
                      turtlesim
                      # keep-sorted end
                    ];
                  };
              }
              // lib.optionalAttrs (system == "x86_64-linux") {
                system-manager = inputs'.system-manager.packages.default;
              }
              // {
                inherit (pkgs)
                  # keep-sorted start
                  aligator
                  colmpc
                  crocoddyl
                  example-robot-data
                  gepetto-viewer
                  hpp-affordance
                  hpp-affordance-corba
                  hpp-baxter
                  hpp-bezier-com-traj
                  hpp-centroidal-dynamics
                  hpp-constraints
                  hpp-corbaserver
                  hpp-core
                  hpp-doc
                  hpp-environments
                  hpp-gepetto-viewer
                  hpp-gui
                  hpp-manipulation
                  hpp-manipulation-corba
                  hpp-manipulation-urdf
                  hpp-pinocchio
                  hpp-plot
                  hpp-practicals
                  hpp-romeo
                  hpp-statistics
                  hpp-template-corba
                  hpp-tutorial
                  hpp-universal-robot
                  hpp-util
                  mim-solvers
                  odri-control-interface
                  odri-masterboard-sdk
                  pinocchio
                  # keep-sorted end
                  ;
              }
              // lib.mapAttrs' (n: lib.nameValuePair "py-${n}") {
                inherit (pkgs.python3Packages)
                  # keep-sorted start
                  aligator
                  brax
                  colmpc
                  crocoddyl
                  example-parallel-robots
                  example-robot-data
                  gepetto-gui
                  hpp-corba
                  hpp-corbaserver
                  hpp-doc
                  hpp-environments
                  hpp-gepetto-viewer
                  hpp-gui
                  hpp-manipulation-corba
                  hpp-plot
                  hpp-practicals
                  hpp-romeo
                  hpp-tutorial
                  hpp-universal-robot
                  mim-solvers
                  pinocchio
                  toolbox-parallel-robots
                  # keep-sorted end
                  ;
              }
              // lib.mapAttrs' (n: lib.nameValuePair "ros-noetic-${n}") (
                lib.optionalAttrs (system == "x86_64-linux") {
                  inherit (pkgs.rosPackages.noetic)
                    # keep-sorted start
                    rosbag
                    rospy
                    # keep-sorted end
                    ;
                }
              )
              // lib.mapAttrs' (n: lib.nameValuePair "ros-humble-${n}") {
                inherit (pkgs.rosPackages.humble)
                  # keep-sorted start
                  agimus-controller-ros
                  agimus-msgs
                  franka-description
                  linear-feedback-controller
                  linear-feedback-controller-msgs
                  # keep-sorted end
                  ;
              }
              // lib.mapAttrs' (n: lib.nameValuePair "ros-jazzy-${n}") {
                inherit (pkgs.rosPackages.jazzy)
                  # keep-sorted start
                  agimus-controller-ros
                  agimus-msgs
                  linear-feedback-controller
                  linear-feedback-controller-msgs
                  # keep-sorted end
                  ;
              }
            );
            treefmt = {
              settings.global.excludes = [
                ".envrc"
                ".git-blame-ignore-revs"
                "LICENSE"
              ];
              programs = {
                # keep-sorted start
                mdformat.enable = true;
                yamlfmt.enable = true;
                # keep-sorted end
              };
            };
          };
      }
    );
}
