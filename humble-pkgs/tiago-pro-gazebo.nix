{
  lib,
  buildRosPackage,
  fetchFromGitHub,

  # nativeBuildInputs
  ament-cmake-auto,

  # propagatedBuildInputs
  allegro-hand-description,
  gazebo-plugins,
  gazebo-ros,
  gazebo-ros2-control,
  launch,
  launch-pal,
  launch-ros,
  omni-base-description,
  pal-gazebo-plugins,
  pal-gazebo-worlds,
  pal-maps,
  pal-pro-gripper-description,
  pal-urdf-utils,
  play-motion2-msgs,
  robot-info-publisher,
  tiago-pro-2dnav,
  tiago-pro-bringup,
  tiago-pro-description,
  tiago-pro-head-description,
  tiago-pro-laser-sensors,
  tiago-pro-moveit-config,

  # checkInputs
  ament-lint-auto,
  ament-lint-common,
}:
buildRosPackage rec {
  pname = "ros-humble-tiago-pro-gazebo";
  version = "1.10.1";

  src = fetchFromGitHub {
    owner = "pal-robotics";
    repo = "tiago_pro_simulation";
    tag = version;
    hash = "sha256-qxY8VL6JhEWZtmmnVS309xPFYhGI1RpQjsI/CZivmfk=";
  };
  sourceRoot = "source/tiago_pro_gazebo";

  buildType = "ament_cmake";

  nativeBuildInputs = [
    ament-cmake-auto
  ];
  propagatedBuildInputs = [
    allegro-hand-description
    gazebo-plugins
    gazebo-ros
    gazebo-ros2-control
    launch
    launch-pal
    launch-ros
    omni-base-description
    pal-gazebo-plugins
    pal-gazebo-worlds
    pal-maps
    pal-pro-gripper-description
    pal-urdf-utils
    play-motion2-msgs
    robot-info-publisher
    tiago-pro-2dnav
    tiago-pro-bringup
    tiago-pro-description
    tiago-pro-head-description
    tiago-pro-laser-sensors
    tiago-pro-moveit-config
  ];
  checkInputs = [
    ament-lint-auto
    ament-lint-common
  ];

  doCheck = false;

  meta = {
    description = "The tiago_pro_gazebo package";
    license = with lib.licenses; [ asl20 ];
    homepage = "https://github.com/pal-robotics/tiago_pro_simulation";
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.nim65s ];
  };
}
