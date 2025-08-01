{
  lib,
  stdenv,

  src-franka-ros2,
  python-with-ament-package,

  # nativeBuildInputs
  ament-cmake,
  ament-index-cpp,
  ament-lint-auto,
  cmake,

  # propagatedBuildInputs
  controller-manager,
  franka-hardware,
  ignition,
  kdl-parser,
  tf2-eigen,
  tf2-geometry-msgs,
  urdf,
  yaml-cpp-vendor,
}:
stdenv.mkDerivation {
  pname = "franka_ign_ros2_control";
  version = "1.0.0";

  src = src-franka-ros2;
  sourceRoot = "source/franka_gazebo/franka_ign_ros2_control";

  env = {
    IGNITION_VERSION = "harmonic";
    PYTHONPATH = python-with-ament-package;
  };

  nativeBuildInputs = [
    ament-cmake
    ament-index-cpp
    ament-lint-auto
    cmake
  ];

  propagatedBuildInputs = [
    controller-manager
    franka-hardware
    ignition.plugin2
    ignition.sim8
    kdl-parser
    tf2-eigen
    tf2-geometry-msgs
    urdf
    yaml-cpp-vendor
  ];

  doCheck = true;
  dontWrapQtApps = true;

  meta = {
    description = "Ignition ros2_control package allows to control simulated robots using ros2_control framework";
    homepage = "https://github.com/agimus-project/franka_ros2";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.linux;
  };
}
