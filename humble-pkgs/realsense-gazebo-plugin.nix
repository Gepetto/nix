{
  lib,
  buildRosPackage,
  fetchFromGitHub,

  # nativeBuildInputs
  ament-cmake,

  # propagatedBuildInputs
  camera-info-manager,
  gazebo-ros,
  image-transport,
  point-cloud-transport,
  rclcpp,
  sensor-msgs,

  # checkInputs
  ament-lint-auto,
  ament-lint-common,
}:
buildRosPackage rec {
  pname = "ros-humble-realsense-gazebo-plugin";
  version = "3.2.0";

  src = fetchFromGitHub {
    owner = "pal-robotics";
    repo = "realsense_gazebo_plugin";
    tag = version;
    hash = "sha256-CPXmGao8reIUi1dH5PY5VFFXqHNzZSKyZ4Mo+jjbCuY=";
  };
  sourceRoot = "source/";

  buildType = "ament_cmake";

  nativeBuildInputs = [
    ament-cmake
  ];
  propagatedBuildInputs = [
    camera-info-manager
    gazebo-ros
    image-transport
    point-cloud-transport
    rclcpp
    sensor-msgs
  ];
  checkInputs = [
    ament-lint-auto
    ament-lint-common
  ];

  doCheck = false;

  meta = {
    description = "Intel RealSense D435 Gazebo plugin package";
    license = with lib.licenses; [ unfree ];
    homepage = "https://github.com/pal-robotics/realsense_gazebo_plugin";
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.nim65s ];
  };
}
