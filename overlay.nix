{
  inputs,
}:
(
  final: prev:
  {
    inherit (inputs)
      # keep-sorted start
      src-colmpc
      src-odri-control-interface
      src-odri-masterboard-sdk
      # keep-sorted end
      ;
    # keep-sorted start block=yes
    gepetto-viewer = prev.gepetto-viewer.overrideAttrs {
      src = inputs.src-gepetto-viewer;
    };
    gz-harmonic = prev.gz-harmonic.overrideAttrs {
      meta.platforms = final.lib.platforms.linux;
    };
    ignition = prev.ignition // {
      sim8 = prev.ignition.sim8.overrideAttrs (super: {
        meta.platforms = final.lib.platforms.linux;
        # add missing include
        patches = (super.patches or [ ]) ++ [
          (final.fetchpatch {
            url = "https://github.com/gazebosim/gz-sim/pull/2414.patch";
            hash = "sha256-zxPN34bA88344h1jrJa9h8NVorlv+hkc+lYEWjhzJCE=";
          })
        ];
      });
    };
    # keep-sorted end
    pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
      (
        python-final: python-prev:
        {
          inherit (inputs)
            # keep-sorted start
            src-agimus-controller
            src-example-parallel-robots
            src-toolbox-parallel-robots
            # keep-sorted end
            ;
          brax = python-prev.brax.overrideAttrs {
            # depends on mujoco
            # which is broken on darwin
            meta.broken = final.stdenv.hostPlatform.isDarwin;
          };
          colmpc = python-final.toPythonModule (
            final.colmpc.override {
              pythonSupport = true;
              python3Packages = python-final;
            }
          );
        }
        // final.lib.filesystem.packagesFromDirectoryRecursive {
          inherit (python-final) callPackage;
          directory = ./py-pkgs;
        }
      )
    ];
    rosPackages = prev.rosPackages // {
      noetic = prev.rosPackages.noetic.overrideScope (
        _noetic-final: noetic-prev: {
          # https://github.com/lopsided98/nix-ros-overlay/blob/develop/distros/noetic/overrides.nix#L206
          # has https://github.com/ros/rosconsole/pull/58.patch
          # but github somehow raises HTTP 429
          rosconsole = noetic-prev.rosconsole.overrideAttrs {
            patches = [ ./patches/ros/rosconsole/58_compatibility-fix-for-liblog4cxx-v011-013.patch ];
          };
          # drop fixed patch
          # ref. https://github.com/lopsided98/nix-ros-overlay/pull/636
          rosgraph = noetic-prev.rosgraph.overrideAttrs {
            patches = [ ];
          };
        }
      );
      humble = prev.rosPackages.humble.overrideScope (
        humble-final: humble-prev:
        {
          inherit (inputs)
            # keep-sorted start
            src-agimus-controller
            src-agimus-msgs
            src-franka-ros2
            # keep-sorted end
            ;
          franka-description = humble-prev.franka-description.overrideAttrs {
            src = inputs.src-franka-description;
            # depends on pyside2 which is broken on darwin
            meta.broken = final.stdenv.hostPlatform.isDarwin;
          };
          franka-bringup = humble-prev.franka-bringup.overrideAttrs {
            src = inputs.src-franka-ros2;
            sourceRoot = "source/franka_bringup";
            meta.platforms = final.lib.platforms.linux;
          };
          franka-hardware = humble-prev.franka-hardware.overrideAttrs (super: {
            src = inputs.src-franka-ros2;
            sourceRoot = "source/franka_hardware";
            propagatedBuildInputs = (super.propagatedBuildInputs or [ ]) ++ [
              humble-final.rclcpp-action
              humble-final.rclcpp-components
            ];
            meta.platforms = final.lib.platforms.linux;
          });

          franka-example-controllers = humble-prev.franka-example-controllers.overrideAttrs (super: {
            src = inputs.src-franka-ros2;
            sourceRoot = "source/franka_example_controllers";
            propagatedBuildInputs = (super.propagatedBuildInputs or [ ]) ++ [
              humble-final.controller-manager
              humble-final.moveit-core
            ];
            meta.platforms = final.lib.platforms.linux;
          });
          franka-fr3-moveit-config = humble-prev.franka-fr3-moveit-config.overrideAttrs (_super: {
            src = inputs.src-franka-ros2;
            sourceRoot = "source/franka_fr3_moveit_config";
            meta.platforms = final.lib.platforms.linux;
          });
          franka-gazebo-bringup = humble-prev.franka-gazebo-bringup.overrideAttrs (_super: {
            src = inputs.src-franka-ros2;
            sourceRoot = "source/franka_gazebo/franka_gazebo_bringup";
            env.PYTHONPATH = humble-final.python-with-ament-package;
            meta.platforms = final.lib.platforms.linux;
          });
          franka-gripper = humble-prev.franka-gripper.overrideAttrs (_super: {
            src = inputs.src-franka-ros2;
            sourceRoot = "source/franka_gripper";
            meta.platforms = final.lib.platforms.linux;
          });
          franka-msgs = humble-prev.franka-msgs.overrideAttrs (_super: {
            src = inputs.src-franka-ros2;
            sourceRoot = "source/franka_msgs";
            meta.platforms = final.lib.platforms.linux;
          });
          franka-robot-state-broadcaster = humble-prev.franka-robot-state-broadcaster.overrideAttrs (super: {
            src = inputs.src-franka-ros2;
            sourceRoot = "source/franka_robot_state_broadcaster";
            propagatedBuildInputs = (super.propagatedBuildInputs or [ ]) ++ [
              humble-final.controller-manager
              humble-final.visualization-msgs
            ];
            meta.platforms = final.lib.platforms.linux;
          });
          franka-ros2 = humble-prev.franka-ros2.overrideAttrs (_super: {
            src = inputs.src-franka-ros2;
            sourceRoot = "source/franka_ros2";
            env.PYTHONPATH = humble-final.python-with-ament-package;
            meta.platforms = final.lib.platforms.linux;
          });
          franka-semantic-components = humble-prev.franka-semantic-components.overrideAttrs (super: {
            src = inputs.src-franka-ros2;
            sourceRoot = "source/franka_semantic_components";
            propagatedBuildInputs = (super.propagatedBuildInputs or [ ]) ++ [
              humble-prev.controller-interface
              humble-final.urdf
            ];
            # https://github.com/ros-controls/ros2_control/pull/2425
            postPatch =
              (super.postPatch or "")
              + ''
                sed -i "1i #include <algorithm>" src/franka_semantic_component_interface.cpp src/franka_cartesian_velocity_interface.cpp
              '';
            meta.platforms = final.lib.platforms.linux;
          });
          python-with-ament-package =
            let
              # TODO: this make no sense
              python = humble-final.python3.withPackages (p: [
                humble-final.ament-package
                p.catkin-pkg
              ]);
            in
            "${python}/${python.sitePackages}";
          ros-gz = humble-prev.ros-gz.overrideAttrs (_super: {
            env.PYTHONPATH = humble-final.python-with-ament-package;
            meta.platforms = final.lib.platforms.linux;
          });
        }
        // final.lib.filesystem.packagesFromDirectoryRecursive {
          inherit (humble-final) callPackage;
          directory = ./humble-pkgs;
        }
      );
      jazzy = prev.rosPackages.jazzy.overrideScope (
        jazzy-final: _jazzy-prev:
        {
          inherit (inputs)
            # keep-sorted start
            src-agimus-controller
            src-agimus-msgs
            # keep-sorted end
            ;
        }
        // final.lib.filesystem.packagesFromDirectoryRecursive {
          inherit (jazzy-final) callPackage;
          directory = ./jazzy-pkgs;
        }
      );
    };
  }
  // prev.lib.filesystem.packagesFromDirectoryRecursive {
    inherit (final) callPackage;
    directory = ./pkgs;
  }
)
