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
  tiago-pro-head-bringup,
  tiago-pro-head-description,

  # checkInputs
  ament-lint-auto,
  ament-lint-common,
}:
buildRosPackage rec {
  pname = "ros-humble-tiago-pro-head-gazebo";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "pal-robotics";
    repo = "tiago_pro_head_simulation";
    tag = version;
    hash = "sha256-JS+4wBv+vXk/BH3X8gUHB0W+iTO+g5kt1TB47SesI2E=";
  };
  sourceRoot = "source/tiago_pro_head_gazebo";

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
    tiago-pro-head-bringup
    tiago-pro-head-description
  ];
  checkInputs = [
    ament-lint-auto
    ament-lint-common
  ];

  doCheck = true;

  meta = {
    description = "The tiago_pro_head_gazebo package";
    license = with lib.licenses; [ asl20 ];
    homepage = "https://github.com/pal-robotics/tiago_pro_head_simulation";
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.nim65s ];
  };
}
