{
  lib,
  python3Packages,

  src-agimus-controller,

  # nativeBuildInputs
  fmt,
  ament-lint-auto,
  ament-copyright,
  ament-flake8,
  ament-pep257,
  generate-parameter-library-py,

  # propagatedBuildInputs
  linear-feedback-controller-msgs,
  launch,
  launch-ros,
  rclpy,
  xacro,
  std-msgs,
  agimus-msgs,
  geometry-msgs,
  builtin-interfaces,
}:
python3Packages.buildPythonPackage {
  pname = "agimus-controller-ros";
  version = "0-unstable-2025-04-23";

  src = src-agimus-controller;
  sourceRoot = "source/agimus_controller_ros";

  dontUseCmakeConfigure = true;
  dontUseCmakeBuild = true;
  dontUseCmakeCheck = true;
  dontUseCmakeInstall = true;

  nativeBuildInputs = [
    fmt
    ament-lint-auto
    ament-copyright
    ament-flake8
    ament-pep257
    generate-parameter-library-py
  ];

  propagatedBuildInputs = [
    python3Packages.agimus-controller
    python3Packages.example-robot-data
    python3Packages.numpy
    python3Packages.pinocchio
    python3Packages.python
    linear-feedback-controller-msgs
    launch
    launch-ros
    rclpy
    xacro
    std-msgs
    agimus-msgs
    geometry-msgs
    builtin-interfaces
  ];

  doCheck = true;
  pythonImportsCheck = [ "agimus_controller_ros" ];

  meta = {
    description = "ROS2 wrapper around the agimus_controller package.";
    homepage = "https://github.com/agimus-project/agimus_controller";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.linux;
  };
}
