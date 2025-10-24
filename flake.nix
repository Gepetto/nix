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
    src-franka-description = {
      url = "github:agimus-project/franka_description";
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
          systemConfigs = {
            default = inputs.system-manager.lib.makeSystemConfig {
              modules = [
                inputs.nix-system-graphics.systemModules.default
                ./modules/system-manager/shared.nix
              ];
            };
            hako = inputs.system-manager.lib.makeSystemConfig {
              modules = [
                inputs.nix-system-graphics.systemModules.default
                ./modules/system-manager/nvidia-570-169.nix
              ];
            };
            miyanoura = inputs.system-manager.lib.makeSystemConfig {
              modules = [
                inputs.nix-system-graphics.systemModules.default
                ./modules/system-manager/nvidia-575-64.nix
              ];
            };
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

            devShells = lib.mapAttrs' (n: v: lib.nameValuePair (lib.removePrefix "dev-shell-" n) v) (
              lib.filterAttrs (n: _v: lib.hasPrefix "dev-shell-" n) self'.packages
            );
            packages = lib.filterAttrs (_n: v: v.meta.available && !v.meta.broken) (
              lib.mapAttrs' (n: lib.nameValuePair "dev-shell-${n}") {
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
                hpp = pkgs.mkShell {
                  name = "dev shell for HPP";
                  CMAKE_C_COMPILER_LAUNCHER = "ccache";
                  CMAKE_CXX_COMPILER_LAUNCHER = "ccache";
                  CMAKE_GENERATOR = "Unix Makefiles";
                  ROS_PACKAGE_PATH = "${pkgs.example-robot-data}/share";
                  shellHook = ''
                    export DEVEL_HPP_DIR=$(pwd -P)
                    mkdir -p $DEVEL_HPP_DIR/{src,install}
                    export INSTALL_HPP_DIR=$DEVEL_HPP_DIR/install
                    export PATH=$INSTALL_HPP_DIR/bin:$PATH
                    export LD_LIBRARY_PATH=$INSTALL_HPP_DIR/lib
                    export PYTHONPATH=$INSTALL_HPP_DIR/${pkgs.python3.sitePackages}
                    export GEPETTO_GUI_PLUGIN_DIRS=$INSTALL_HPP_DIR/lib/gepetto-gui-plugins
                    export HPP_PLUGIN_DIRS=$INSTALL_HPP_DIR/lib/hppPlugins
                  '';
                  packages =
                    with pkgs;
                    [
                      assimp
                      ccache
                      cddlib
                      clp
                      cmake
                      console-bridge
                      doxygen
                      eigen
                      glpk
                      graphviz
                      libGL
                      libsForQt5.qtbase
                      libsForQt5.qttools
                      octomap
                      openscenegraph
                      osgqt
                      pkg-config
                      (python3.withPackages (
                        p: with p; [
                          lxml
                          numpy
                          omniorb
                          omniorbpy
                          pybind11
                          python-qt
                          scipy
                          (toPythonModule rosPackages.rolling.xacro)
                          viser
                        ]
                      ))
                      python3Packages.boost
                      qhull
                      qpoases
                      tinyxml-2
                      urdfdom
                      zlib
                    ]
                    ++ lib.optionals stdenv.isLinux [
                      psmisc
                    ];
                };
                hpp-bin = pkgs.mkShell {
                  packages = [
                    (pkgs.python3.withPackages (p: [
                      p.gepetto-gui
                      p.hpp-corba
                    ]))
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
              }
              // {
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
                  aig
                  aligator
                  biped-stabilizer
                  colmpc
                  crocoddyl
                  example-robot-data
                  flex-joints
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
                  hpp-tools
                  hpp-tutorial
                  hpp-universal-robot
                  hpp-util
                  mim-solvers
                  multicontact-api
                  ndcurves
                  odri-control-interface
                  odri-masterboard-sdk
                  pinocchio
                  tsid
                  # keep-sorted end
                  ;
              }
              // lib.mapAttrs' (n: lib.nameValuePair "py-${n}") {
                inherit (pkgs.python3Packages)
                  # keep-sorted start
                  aig
                  aligator
                  biped-stabilizer
                  brax
                  colmpc
                  crocoddyl
                  example-parallel-robots
                  example-robot-data
                  flex-joints
                  gepetto-gui
                  gepetto-viewer
                  gepetto-viewer-corba
                  hpp-affordance-corba
                  hpp-corba
                  hpp-corbaserver
                  hpp-doc
                  hpp-environments
                  hpp-gepetto-viewer
                  hpp-gui
                  hpp-manipulation-corba
                  hpp-plot
                  hpp-practicals
                  hpp-python
                  hpp-romeo
                  hpp-tutorial
                  hpp-universal-robot
                  mim-solvers
                  multicontact-api
                  ndcurves
                  pinocchio
                  platypus
                  sensitivity
                  toolbox-parallel-robots
                  tsid
                  # keep-sorted end
                  ;
              }
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
