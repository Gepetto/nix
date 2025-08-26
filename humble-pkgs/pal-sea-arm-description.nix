{
  lib,
  buildRosPackage,
  fetchFromGitHub,

  # nativeBuildInputs
  ament-cmake-auto,
  ament-cmake-python,

  # propagatedBuildInputs
  allegro-hand-description,
  allegro-hand-system,
  joint-state-publisher-gui,
  launch,
  launch-pal,
  launch-param-builder,
  launch-ros,
  pal-pro-gripper-description,
  pal-sea-arm-controller-configuration,
  pal-urdf-utils,
  robot-state-publisher,
  sea-transmissions,
  xacro,

  # checkInputs
  ament-cmake-pytest,
  ament-lint-auto,
  ament-lint-common,
  launch-testing-ament-cmake,
  urdf-test,
}:
buildRosPackage rec {
  pname = "ros-humble-pal-sea-arm-description";
  version = "1.18.7";

  src = fetchFromGitHub {
    owner = "pal-robotics";
    repo = "pal_sea_arm";
    tag = version;
    hash = "sha256-VoJQepKxkCMTQECaOnYjCdEvfKq+n2zNyhGkgvotkoI=";
  };
  sourceRoot = "source/pal_sea_arm_description";

  buildType = "ament_cmake";

  nativeBuildInputs = [
    ament-cmake-auto
    ament-cmake-python
  ];
  propagatedBuildInputs = [
    allegro-hand-description
    allegro-hand-system
    joint-state-publisher-gui
    launch
    launch-pal
    launch-param-builder
    launch-ros
    pal-pro-gripper-description
    pal-sea-arm-controller-configuration
    pal-urdf-utils
    robot-state-publisher
    sea-transmissions
    xacro
  ];
  checkInputs = [
    ament-cmake-pytest
    ament-lint-auto
    ament-lint-common
    launch-testing-ament-cmake
    urdf-test
  ];

  doCheck = false;

  meta = {
    description = "The pal_sea_arm_description package";
    license = with lib.licenses; [
      unfree
      asl20
    ];
    homepage = "https://github.com/pal-robotics/pal_sea_arm";
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.nim65s ];
  };
}
