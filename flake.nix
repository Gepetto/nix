{
  inputs = {
    gazebros2nix.url = "github:gepetto/gazebros2nix";
    flakoboros.follows = "gazebros2nix/flakoboros";
    flake-parts.follows = "gazebros2nix/flake-parts";
    nixpkgs.follows = "gazebros2nix/nixpkgs";
    nix-ros-overlay.follows = "gazebros2nix/nix-ros-overlay";
    systems.follows = "gazebros2nix/systems";
    treefmt-nix.follows = "gazebros2nix/treefmt-nix";

    nixpkgs-update.url = "github:NixOS/nixpkgs/nixos-unstable";
    system-manager = {
      url = "github:numtide/system-manager";
      inputs.nixpkgs.follows = "nixpkgs-update";
    };
    nix-system-graphics = {
      url = "github:soupglasses/nix-system-graphics";
      inputs.nixpkgs.follows = "nixpkgs-update";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-update";
    };
  };
  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } (
      { lib, ... }:
      let
        flakeModule = inputs.flake-parts.lib.importApply ./module.nix {
          inherit (inputs) gazebros2nix;
        };
      in
      {
        systems = import inputs.systems;
        imports = [
          flakeModule
          inputs.home-manager.flakeModules.home-manager
          {
            flakoboros.check = true;
          }
        ];
        flake = {
          inherit flakeModule;
          lib.mkFlakoboros =
            localInputs: module:
            inputs.flake-parts.lib.mkFlake { inputs = localInputs; } (args: {
              systems = import inputs.systems;
              imports = [
                flakeModule
                { flakoboros = module args; }
              ];
            });
          homeConfigurations = import ./modules/home-manager {
            inherit lib;
            inherit (inputs) home-manager nixpkgs;
          };
          systemConfigs = import ./modules/system-manager {
            inherit lib;
            inherit (inputs) nix-system-graphics system-manager;
          };
          templates = {
            default = {
              path = ./templates/default;
              description = "A template for use with gepetto/nix";
            };
            ros = {
              path = ./templates/ros;
              description = "A template for use with gepetto/nix and ROS";
            };
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
                  # keep-sorted end
                ];
              };

              vscode = pkgs.mkShell {
                packages = [
                  self'.packages.vscode
                ]
                ++ lib.optional pkgs.stdenv.hostPlatform.isLinux pkgs.cudaPackages.cudatoolkit;
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
                    python3Packages.boost
                    assimp
                    catch2_3
                    ccache
                    cddlib
                    clp
                    cmake
                    console-bridge
                    doxygen
                    eigen
                    example-robot-data
                    glpk
                    graphviz
                    libGL
                    libsForQt5.qtbase
                    libsForQt5.qttools
                    nodejs_24
                    octomap
                    openscenegraph
                    osgqt
                    pinocchio
                    pkg-config
                    proxsuite
                    (python3.withPackages (
                      p: with p; [
                        example-robot-data
                        lxml
                        numpy
                        omniorb
                        omniorbpy
                        pinocchio
                        pybind11
                        python-qt
                        scipy
                        (toPythonModule rosPackages.rolling.xacro)
                        viser
                      ]
                    ))
                    qgv
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
                ROS_PACKAGE_PATH = lib.makeSearchPathOutput "out" "share" [
                  pkgs.example-robot-data
                  pkgs.hpp-environments
                ];
                packages = [
                  # keep-sorted start
                  pkgs.hpp-affordance
                  pkgs.hpp-constraints
                  pkgs.hpp-core
                  pkgs.hpp-manipulation
                  pkgs.hpp-manipulation-urdf
                  pkgs.hpp-pinocchio
                  pkgs.hpp-statistics
                  pkgs.hpp-tools
                  pkgs.hpp-util
                  # keep-sorted end
                  (pkgs.python3.withPackages (p: [
                    # keep-sorted start
                    p.hpp-affordance-corba
                    p.hpp-baxter
                    p.hpp-bezier-com-traj
                    p.hpp-centroidal-dynamics
                    p.hpp-corbaserver
                    p.hpp-environments
                    p.hpp-exec
                    p.hpp-gepetto-viewer
                    p.hpp-gui
                    p.hpp-manipulation-corba
                    p.hpp-plot
                    p.hpp-practicals
                    p.hpp-python
                    p.hpp-romeo
                    # p.hpp-rviz
                    p.hpp-toppra
                    p.hpp-tutorial
                    p.hpp-universal-robot
                    # keep-sorted end
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

            legacyPackages = pkgs;

            packages = {
              inherit (inputs'.home-manager.packages) home-manager;
            }
            // lib.filterAttrs (_n: v: v.meta.available && !v.meta.broken) (
              {
                python = pkgs.python3.withPackages (p: [
                  # keep-sorted start
                  p.crocoddyl
                  p.gepetto-gui
                  p.hpp-corba
                  p.ipython
                  p.matplotlib
                  # keep-sorted end
                ]);
                ros-humble = pkgs.rosPackages.humble.buildEnv {
                  name = "ros-humble";
                  postBuild = inputs.flakoboros.lib.rosWrapperArgs pkgs "humble" { };
                  paths = lib.attrValues (lib.filterAttrs (n: _p: lib.hasPrefix "ros-humble-" n) self'.packages) ++ [
                    pkgs.qt5.qtgraphicaleffects
                    pkgs.qt5.wrapQtAppsHook
                  ];
                };

                ros-jazzy = pkgs.rosPackages.jazzy.buildEnv {
                  name = "ros-jazzy";
                  postBuild = inputs.flakoboros.lib.rosWrapperArgs pkgs "jazzy" { };
                  paths = lib.attrValues (lib.filterAttrs (n: _p: lib.hasPrefix "ros-jazzy-" n) self'.packages) ++ [
                    pkgs.qt5.wrapQtAppsHook
                  ];
                };

                ros-kilted = pkgs.rosPackages.kilted.buildEnv {
                  name = "ros-kilted";
                  postBuild = inputs.flakoboros.lib.rosWrapperArgs pkgs "kilted" { };
                  paths = lib.attrValues (lib.filterAttrs (n: _p: lib.hasPrefix "ros-kilted-" n) self'.packages) ++ [
                    pkgs.qt5.wrapQtAppsHook
                  ];
                };

                ros-lyrical = pkgs.rosPackages.lyrical.buildEnv {
                  name = "ros-lyrical";
                  postBuild = inputs.flakoboros.lib.rosWrapperArgs pkgs "lyrical" { };
                  paths = lib.attrValues (lib.filterAttrs (n: _p: lib.hasPrefix "ros-lyrical-" n) self'.packages) ++ [
                    pkgs.qt6.wrapQtAppsHook
                  ];
                };

                ros-rolling = pkgs.rosPackages.rolling.buildEnv {
                  name = "ros-rolling";
                  postBuild = inputs.flakoboros.lib.rosWrapperArgs pkgs "rolling" { };
                  paths = lib.attrValues (lib.filterAttrs (n: _p: lib.hasPrefix "ros-rolling-" n) self'.packages) ++ [
                    pkgs.qt6.wrapQtAppsHook
                  ];
                };

                vscode =
                  let
                    # This contain coreutils and a 'id' binary not configured for LDAP,
                    # so at LAAS, vscode 'id -u -n' fails
                    id-link = pkgs.runCommand "id-link" { } ''
                      mkdir -p $out/bin
                      ln -s /usr/bin/id $out/bin/id
                    '';
                  in
                  pkgs.vscode-with-extensions.override {
                    vscode = pkgs.vscode.overrideAttrs (super: {
                      preFixup = super.preFixup + ''
                        gappsWrapperArgs+=(
                          --prefix PATH : ${id-link}/bin
                          --add-flags --no-sandbox
                        )
                      '';
                    });
                    vscodeExtensions = with pkgs.vscode-extensions.ms-vscode-remote; [
                      remote-containers
                    ];
                  };

              }
              // lib.optionalAttrs (system == "x86_64-linux") {
                system-manager = inputs'.system-manager.packages.default;
              }
              // {
                inherit (pkgs)
                  # keep-sorted start
                  acados
                  aig
                  aligator
                  biped-stabilizer
                  casadi
                  coal
                  colmpc
                  cppadcodegen
                  crocoddyl
                  example-adder
                  example-robot-data
                  flex-joints
                  force-feedback-mpc
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
                  hpp-exec
                  hpp-gepetto-viewer
                  hpp-gui
                  hpp-manipulation
                  hpp-manipulation-corba
                  hpp-manipulation-urdf
                  hpp-pinocchio
                  hpp-plot
                  hpp-practicals
                  hpp-python
                  hpp-romeo
                  hpp-statistics
                  hpp-template-corba
                  hpp-tools
                  hpp-toppra
                  hpp-tutorial
                  hpp-universal-robot
                  hpp-util
                  jrl-cmakemodules
                  mim-solvers
                  multicontact-api
                  ndcurves
                  odri-control-interface
                  odri-masterboard-sdk
                  pinocchio
                  proxsuite
                  toppra
                  tsid
                  unitree-sdk2
                  # keep-sorted end
                  ;
              }
              // lib.mapAttrs' (n: lib.nameValuePair "py-${n}") {
                inherit (pkgs.python3Packages)
                  # keep-sorted start
                  aig
                  aligator
                  biped-stabilizer
                  # brax TODO https://github.com/tensorflow/tensorflow/issues/102890
                  casadi
                  coal
                  colmpc
                  crocoddyl
                  cyclonedds-python_10
                  example-adder
                  example-parallel-robots
                  example-robot-data
                  flex-joints
                  force-feedback-mpc
                  gepetto-gui
                  gepetto-viewer
                  gepetto-viewer-corba
                  hpp-affordance-corba
                  hpp-corba
                  hpp-corbaserver
                  hpp-doc
                  hpp-environments
                  hpp-exec
                  hpp-gepetto-viewer
                  hpp-gui
                  hpp-manipulation-corba
                  hpp-plot
                  hpp-practicals
                  hpp-python
                  hpp-romeo
                  hpp-toppra
                  hpp-tutorial
                  hpp-universal-robot
                  inspire-hand-sdk
                  mim-solvers
                  multicontact-api
                  ndcurves
                  pin-pink
                  pinocchio
                  platypus
                  proxsuite
                  pycppad
                  sensitivity
                  toolbox-parallel-robots
                  toppra
                  tsid
                  unitree-sdk2-python
                  viser
                  # keep-sorted end
                  ;
              }
              // lib.mapAttrs' (n: lib.nameValuePair "ros-humble-${n}") {
                inherit (pkgs.rosPackages.humble)
                  agimus-demo-03-mpc-dummy-traj
                  hpp-rviz
                  quest-control
                  ;
              }
              // lib.mapAttrs' (n: lib.nameValuePair "ros-jazzy-${n}") {
                inherit (pkgs.rosPackages.jazzy)
                  agimus-demo-03-mpc-dummy-traj
                  tiago-pro-gazebo
                  # TODO : those 4 are required for tiago_pro_gazebo tiago_pro_gazebo.launch.py, this should not be the case
                  br2-gazebo-worlds
                  hpp-rviz
                  ros2launch
                  ros-gz-bridge
                  ros-gz-image
                  ;
              }
              // lib.mapAttrs' (n: lib.nameValuePair "ros-kilted-${n}") {
                inherit (pkgs.rosPackages.kilted)
                  hpp-rviz
                  ;
              }
              // lib.mapAttrs' (n: lib.nameValuePair "ros-lyrical-${n}") {
                inherit (pkgs.rosPackages.lyrical)
                  hpp-rviz
                  ;
              }
              // lib.mapAttrs' (n: lib.nameValuePair "ros-rolling-${n}") {
                inherit (pkgs.rosPackages.rolling)
                  hpp-rviz
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
