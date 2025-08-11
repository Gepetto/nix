{
  lib,
  buildRosPackage,
  fetchFromGitHub,

  # nativeBuildInputs
  ament-cmake-auto,

  # propagatedBuildInputs
  ament-index-python,
  collision-aware-joint-trajectory-wrapper,
  diagnostic-aggregator,
  joy-linux,
  joy-teleop,
  pal-pro-gripper-wrapper,
  play-motion2,
  tiago-pro-controller-configuration,
  tiago-pro-head-bringup,
  twist-mux,

  # checkInputs
  ament-lint-auto,
  ament-lint-common,
}:
buildRosPackage rec {
  pname = "ros-humble-tiago-pro-bringup";
  version = "1.30.0";

  src = fetchFromGitHub {
    owner = "pal-robotics";
    repo = "tiago_pro_robot";
    tag = version;
    hash = "sha256-2YoWKZgJoEaEhkpW0nlfoHjKtbFc/GZ0ieQKPhQD7Do=";
  };
  sourceRoot = "source/tiago_pro_bringup";

  buildType = "ament_cmake";

  nativeBuildInputs = [
    ament-cmake-auto
  ];
  propagatedBuildInputs = [
    ament-index-python
    collision-aware-joint-trajectory-wrapper
    diagnostic-aggregator
    joy-linux
    joy-teleop
    pal-pro-gripper-wrapper
    play-motion2
    tiago-pro-controller-configuration
    tiago-pro-head-bringup
    twist-mux
  ];
  checkInputs = [
    ament-lint-auto
    ament-lint-common
  ];

  doCheck = false;

  meta = {
    description = "Launch files to upload the TIAGo pro robot description and start the controllers";
    license = with lib.licenses; [ asl20 ];
    homepage = "https://github.com/pal-robotics/tiago_pro_robot";
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.nim65s ];
  };
}
