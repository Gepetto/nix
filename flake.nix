{
  inputs = {
    gazebros2nix.url = "github:gepetto/gazebros2nix";
    flakoboros.follows = "gazebros2nix/flakoboros";
    flake-parts.follows = "gazebros2nix/flake-parts";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs.follows = "gazebros2nix/nixpkgs";
    nix-ros-overlay.follows = "gazebros2nix/nix-ros-overlay";
    systems.follows = "gazebros2nix/systems";
    treefmt-nix.follows = "gazebros2nix/treefmt-nix";

    nix-system-graphics = {
      url = "github:soupglasses/nix-system-graphics";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    system-manager = {
      url = "github:numtide/system-manager";
      inputs.nixpkgs.follows = "nixpkgs";
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
          homeConfigurations.cpene = inputs.home-manager.lib.homeManagerConfiguration {
            pkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
            modules = [ ./home/cpene.nix ];
          };
          lib.mkFlakoboros =
            localInputs: module:
            inputs.flake-parts.lib.mkFlake { inputs = localInputs; } (args: {
              systems = import inputs.systems;
              imports = [
                flakeModule
                { flakoboros = module args; }
              ];
            });
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
            osasa = inputs.system-manager.lib.makeSystemConfig {
              modules = [
                inputs.nix-system-graphics.systemModules.default
                ./modules/system-manager/nvidia-590-48.nix
              ];
            };
            tomuraushi = inputs.system-manager.lib.makeSystemConfig {
              modules = [
                inputs.nix-system-graphics.systemModules.default
                ./modules/system-manager/nvidia-580-126.nix
              ];
            };
            yamizoyama = inputs.system-manager.lib.makeSystemConfig {
              modules = [
                inputs.nix-system-graphics.systemModules.default
                ./modules/system-manager/nvidia-590-48.nix
              ];
            };
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
                        pinocchio
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
                ROS_PACKAGE_PATH = lib.makeSearchPathOutput "out" "share" [
                  pkgs.example-robot-data
                  pkgs.hpp-environments
                ];
                packages = [
                  (pkgs.python3.withPackages (p: [
                    # p.gepetto-gui
                    p.hpp-gepetto-viewer
                    p.hpp-plot
                    # p.pinocchio
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
                  aig
                  aligator
                  biped-stabilizer
                  casadi
                  coal
                  colmpc
                  crocoddyl
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
                  casadi
                  coal
                  colmpc
                  crocoddyl
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
                  mim-solvers
                  multicontact-api
                  ndcurves
                  pinocchio
                  platypus
                  proxsuite
                  sensitivity
                  toolbox-parallel-robots
                  toppra
                  tsid
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
