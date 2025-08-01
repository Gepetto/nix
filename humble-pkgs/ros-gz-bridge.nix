# Copyright 2025 Open Source Robotics Foundation
# Distributed under the terms of the BSD license

{
  lib,
  buildRosPackage,
  fetchurl,
  actuator-msgs,
  ament-cmake,
  ament-cmake-gtest,
  ament-cmake-python,
  ament-lint-auto,
  ament-lint-common,
  geometry-msgs,
  gps-msgs,
  ignition,
  launch,
  launch-ros,
  launch-testing,
  launch-testing-ament-cmake,
  nav-msgs,
  pkg-config,
  rclcpp,
  rclcpp-components,
  ros-gz-interfaces,
  rosgraph-msgs,
  sensor-msgs,
  std-msgs,
  tf2-msgs,
  trajectory-msgs,
  vision-msgs,
  yaml-cpp-vendor,
}:
buildRosPackage {
  pname = "ros-humble-ros-gz-bridge";
  version = "0.244.20-r1";

  src = fetchurl {
    url = "https://github.com/ros2-gbp/ros_ign-release/archive/release/humble/ros_gz_bridge/0.244.20-1.tar.gz";
    name = "0.244.20-1.tar.gz";
    hash = "sha256-Lofn1Sc//FvA2iNYDdtak5UJg5XIvOWWha7knnlCj2w=";
  };

  buildType = "ament_cmake";
  buildInputs = [
    ament-cmake
    ament-cmake-python
    pkg-config
  ];
  checkInputs = [
    ament-cmake-gtest
    ament-lint-auto
    ament-lint-common
    launch-ros
    launch-testing
    launch-testing-ament-cmake
  ];
  propagatedBuildInputs = [
    actuator-msgs
    geometry-msgs
    gps-msgs
    ignition.msgs10
    ignition.transport13
    launch
    launch-ros
    nav-msgs
    rclcpp
    rclcpp-components
    ros-gz-interfaces
    rosgraph-msgs
    sensor-msgs
    std-msgs
    tf2-msgs
    trajectory-msgs
    vision-msgs
    yaml-cpp-vendor
  ];
  nativeBuildInputs = [
    ament-cmake
    ament-cmake-python
    pkg-config
  ];

  env.GZ_VERSION = "harmonic";

  meta = {
    description = "Bridge communication between ROS and Gazebo Transport";
    license = with lib.licenses; [ asl20 ];
  };
}
