{
  lib,
  stdenv,

  src-agimus-controller,

  # nativeBuildInputs
  cmake,
  fmt,
  python3Packages,
  ament-cmake,
  ament-lint-auto,
  ament-cmake-auto,
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
stdenv.mkDerivation (finalAttrs: {
  pname = "agimus-controller-ros";
  version = "0-unstable-2025-04-23";

  src = lib.sourceInfo src-agimus-controller "agimus_controller_ros";

  nativeBuildInputs = [
    cmake
    fmt
    ament-cmake
    ament-cmake-auto
    ament-lint-auto
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

  # revert https://github.com/lopsided98/nix-ros-overlay/blob/develop/distros/rosidl-generator-py-setup-hook.sh
  # as they break tests
  postConfigure = ''
    cmake $cmakeDir -DCMAKE_SKIP_BUILD_RPATH:BOOL=OFF
  '';

  doCheck = true;

  # generate_parameter_library_markdown complains that build/doc exists
  # ref. https://github.com/PickNikRobotics/generate_parameter_library/pull/212
  enableParallelBuilding = false;

  meta = {
    description = "ROS2 wrapper around the agimus_controller package.";
    homepage = "https://github.com/agimus-project/agimus_controller";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.linux;
  };
})
