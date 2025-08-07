{
  lib,
  buildRosPackage,
  fetchFromGitHub,

  # nativeBuildInputs
  ament-cmake,
  pkg-config,

  # propagatedBuildInputs
  asio,
  asio-cmake-module,
  curl,
  curlpp,
  hardware-interface,
  pluginlib,
  rclcpp,
  rclcpp-lifecycle,
  tinyxml2,

# checkInputs
}:
buildRosPackage rec {
  pname = "ros-humble-net-ft-driver";
  version = "0.0.0";

  src = fetchFromGitHub {
    owner = "gbartyzel";
    repo = "ros2_net_ft_driver";
    rev = "393960c20c1607bbdeec7bff70ce5b4db01e3ab3";
    hash = "sha256-TbTs7PmP98WyCIslfgdh+TLHi8jZZXgjEiHoFnIQXZw=";
  };
  sourceRoot = "source/net_ft_driver";

  buildType = "ament_cmake";

  nativeBuildInputs = [
    ament-cmake
    pkg-config
  ];
  propagatedBuildInputs = [
    asio
    asio-cmake-module
    curl
    curlpp
    hardware-interface
    pluginlib
    rclcpp
    rclcpp-lifecycle
    tinyxml2
  ];
  checkInputs = [
  ];

  doCheck = true;

  meta = {
    description = "ROS2 driver for Net F/T sensors (ATI, ATI Axia, OnRobot)";
    license = with lib.licenses; [ unfree ];
    homepage = "https://github.com/gbartyzel/ros2_net_ft_driver";
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.nim65s ];
  };
}
