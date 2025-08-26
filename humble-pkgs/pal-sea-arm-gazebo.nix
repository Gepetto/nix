{
  lib,
  buildRosPackage,
  fetchFromGitHub,

  # nativeBuildInputs
  ament-cmake-auto,

  # propagatedBuildInputs
  gazebo-plugins,
  gazebo-ros,
  gazebo-ros2-control,
  launch,
  launch-pal,
  launch-ros,
  pal-gazebo-plugins,
  pal-gazebo-worlds,
  pal-pro-gripper-description,
  pal-sea-arm-bringup,
  pal-sea-arm-description,
  pal-sea-arm-moveit-config,
  pal-urdf-utils,

  # checkInputs
  ament-lint-auto,
  ament-lint-common,
}:
buildRosPackage rec {
  pname = "ros-humble-pal-sea-arm-gazebo";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "pal-robotics";
    repo = "pal_sea_arm_simulation";
    tag = version;
    hash = "sha256-0UPWs4TLLf9rffQAbk0wEoDDyRJUPCOkMxCTQ42Kd+E=";
  };
  sourceRoot = "source/pal_sea_arm_gazebo";

  buildType = "ament_cmake";

  nativeBuildInputs = [
    ament-cmake-auto
  ];
  propagatedBuildInputs = [
    gazebo-plugins
    gazebo-ros
    gazebo-ros2-control
    launch
    launch-pal
    launch-ros
    pal-gazebo-plugins
    pal-gazebo-worlds
    pal-pro-gripper-description
    pal-sea-arm-bringup
    pal-sea-arm-description
    pal-sea-arm-moveit-config
    pal-urdf-utils
  ];
  checkInputs = [
    ament-lint-auto
    ament-lint-common
  ];

  doCheck = true;

  meta = {
    description = "The pal_sea_arm_gazebo package";
    license = with lib.licenses; [ asl20 ];
    homepage = "https://github.com/pal-robotics/pal_sea_arm_simulation";
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.nim65s ];
  };
}
