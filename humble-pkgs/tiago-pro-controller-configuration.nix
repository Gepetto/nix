{
  lib,
  buildRosPackage,
  fetchFromGitHub,

  # nativeBuildInputs
  ament-cmake-auto,

  # propagatedBuildInputs
  allegro-hand-controller-configuration,
  gravity-compensation-controller2,
  joint-state-broadcaster,
  joint-trajectory-controller,
  launch,
  launch-pal,
  omni-base-controller-configuration,
  omni-drive-controller,
  pal-pro-gripper-controller-configuration,
  pal-sea-arm-controller-configuration,
  ros2controlcli,
  tiago-pro-head-controller-configuration,
  tsid-controllers,

  # checkInputs
  ament-lint-auto,
  ament-lint-common,
}:
buildRosPackage rec {
  pname = "ros-humble-tiago-pro-controller-configuration";
  version = "1.30.0";

  src = fetchFromGitHub {
    owner = "pal-robotics";
    repo = "tiago_pro_robot";
    tag = version;
    hash = "sha256-2YoWKZgJoEaEhkpW0nlfoHjKtbFc/GZ0ieQKPhQD7Do=";
  };
  sourceRoot = "source/tiago_pro_controller_configuration";

  buildType = "ament_cmake";

  nativeBuildInputs = [
    ament-cmake-auto
  ];
  propagatedBuildInputs = [
    allegro-hand-controller-configuration
    gravity-compensation-controller2
    joint-state-broadcaster
    joint-trajectory-controller
    launch
    launch-pal
    omni-base-controller-configuration
    omni-drive-controller
    pal-pro-gripper-controller-configuration
    pal-sea-arm-controller-configuration
    ros2controlcli
    tiago-pro-head-controller-configuration
    tsid-controllers
  ];
  checkInputs = [
    ament-lint-auto
    ament-lint-common
  ];

  doCheck = false;

  meta = {
    description = "The tiago_pro_controller_configuration package";
    license = with lib.licenses; [ asl20 ];
    homepage = "https://github.com/pal-robotics/tiago_pro_robot";
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.nim65s ];
  };
}
