# Copyright 2025 Open Source Robotics Foundation
# Distributed under the terms of the BSD license

{
  lib,
  buildRosPackage,
  fetchurl,
  ament-cmake,
  ament-lint-auto,
  ament-lint-common,
  ignition,
  image-transport,
  pkg-config,
  rclcpp,
  ros-gz-bridge,
  sensor-msgs,
}:
buildRosPackage {
  pname = "ros-humble-ros-gz-image";
  version = "0.244.20-r1";

  src = fetchurl {
    url = "https://github.com/ros2-gbp/ros_ign-release/archive/release/humble/ros_gz_image/0.244.20-1.tar.gz";
    name = "0.244.20-1.tar.gz";
    hash = "sha256-dLj/SW2jbHSN6i/8Ae13fDPPBnoA8KXl3vBVASH0FN4=";
  };

  buildType = "ament_cmake";
  buildInputs = [
    ament-cmake
    pkg-config
  ];
  checkInputs = [
    ament-lint-auto
    ament-lint-common
  ];
  propagatedBuildInputs = [
    ignition.msgs10
    ignition.transport13
    image-transport
    rclcpp
    ros-gz-bridge
    sensor-msgs
  ];
  nativeBuildInputs = [
    ament-cmake
    pkg-config
  ];

  env.GZ_VERSION = "harmonic";

  meta = {
    description = "Image utilities for Gazebo simulation with ROS.";
    license = with lib.licenses; [ asl20 ];
  };
}
