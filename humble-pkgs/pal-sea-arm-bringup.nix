{
  lib,
  buildRosPackage,
  fetchFromGitHub,

  # nativeBuildInputs
  ament-cmake-auto,

  # propagatedBuildInputs
  joint-state-broadcaster,
  joint-trajectory-controller,
  joy,
  joy-teleop,
  launch-pal,
  pal-sea-arm-controller-configuration,
  pal-sea-arm-description,
  play-motion2,

  # checkInputs
  ament-lint-auto,
  ament-lint-common,
}:
buildRosPackage rec {
  pname = "ros-humble-pal-sea-arm-bringup";
  version = "1.18.7";

  src = fetchFromGitHub {
    owner = "pal-robotics";
    repo = "pal_sea_arm";
    tag = version;
    hash = "sha256-VoJQepKxkCMTQECaOnYjCdEvfKq+n2zNyhGkgvotkoI=";
  };
  sourceRoot = "source/pal_sea_arm_bringup";

  buildType = "ament_cmake";

  nativeBuildInputs = [
    ament-cmake-auto
  ];
  propagatedBuildInputs = [
    joint-state-broadcaster
    joint-trajectory-controller
    joy
    joy-teleop
    launch-pal
    pal-sea-arm-controller-configuration
    pal-sea-arm-description
    play-motion2
  ];
  checkInputs = [
    ament-lint-auto
    ament-lint-common
  ];

  doCheck = true;

  meta = {
    description = "Launch files to upload the robot description and start the controllers";
    license = with lib.licenses; [ asl20 ];
    homepage = "https://github.com/pal-robotics/pal_sea_arm";
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.nim65s ];
  };
}
