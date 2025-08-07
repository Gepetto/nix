{
  lib,
  buildRosPackage,
  fetchFromGitHub,

  # nativeBuildInputs
  ament-cmake-auto,

  # propagatedBuildInputs
  controller-manager,
  inertia-shaping-effort-control,
  joint-trajectory-controller,
  launch,
  launch-pal,
  pal-pro-gripper-controller-configuration,
  sea-state-broadcaster,

  # checkInputs
  ament-lint-auto,
  ament-lint-common,
}:
buildRosPackage rec {
  pname = "ros-humble-pal-sea-arm-controller-configuration";
  version = "1.18.7";

  src = fetchFromGitHub {
    owner = "pal-robotics";
    repo = "pal_sea_arm";
    tag = version;
    hash = "sha256-VoJQepKxkCMTQECaOnYjCdEvfKq+n2zNyhGkgvotkoI=";
  };
  sourceRoot = "source/pal_sea_arm_controller_configuration";

  buildType = "ament_cmake";

  nativeBuildInputs = [
    ament-cmake-auto
  ];
  propagatedBuildInputs = [
    controller-manager
    inertia-shaping-effort-control
    joint-trajectory-controller
    launch
    launch-pal
    pal-pro-gripper-controller-configuration
    sea-state-broadcaster
  ];
  checkInputs = [
    ament-lint-auto
    ament-lint-common
  ];

  doCheck = false;

  meta = {
    description = "The pal_sea_arm_controller_configuration package";
    license = with lib.licenses; [ asl20 ];
    homepage = "https://github.com/pal-robotics/pal_sea_arm";
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.nim65s ];
  };
}
