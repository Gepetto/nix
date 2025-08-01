# Copyright 2025 Open Source Robotics Foundation
# Distributed under the terms of the BSD license

{
  lib,
  buildRosPackage,
  fetchurl,
  ament-cmake,
  ament-cmake-python,
  ament-index-python,
  ament-lint-auto,
  ament-lint-common,
  ament-package,
  builtin-interfaces,
  cli11,
  geometry-msgs,
  gflags,
  ignition,
  launch,
  launch-ros,
  launch-testing,
  launch-testing-ament-cmake,
  pkg-config,
  rclcpp,
  rclcpp-components,
  rcpputils,
  ros-gz-interfaces,
  std-msgs,
  tf2,
  tf2-ros,
  python-with-ament-package,
}:
buildRosPackage {
  pname = "ros-humble-ros-gz-sim";
  version = "0.244.20-r1";

  src = fetchurl {
    url = "https://github.com/ros2-gbp/ros_ign-release/archive/release/humble/ros_gz_sim/0.244.20-1.tar.gz";
    name = "0.244.20-1.tar.gz";
    hash = "sha256-Bck+Dzpi1N4XWSbbUnB/AXnSfPfp3Rq1gpRp1WYDPLw=";
  };

  buildType = "ament_cmake";
  buildInputs = [
    ament-cmake
    ament-cmake-python
    ament-package
    pkg-config
  ];
  checkInputs = [
    ament-lint-auto
    ament-lint-common
    launch-ros
    launch-testing
    launch-testing-ament-cmake
  ];
  propagatedBuildInputs = [
    ament-index-python
    builtin-interfaces
    cli11
    geometry-msgs
    gflags
    ignition.math7
    ignition.msgs10
    ignition.sim8
    ignition.transport13
    launch
    launch-ros
    rclcpp
    rclcpp-components
    rcpputils
    ros-gz-interfaces
    std-msgs
    tf2
    tf2-ros
  ];
  nativeBuildInputs = [
    ament-cmake
    ament-cmake-python
    pkg-config
  ];

  env = {
    GZ_VERSION = "harmonic";
    PYTHONPATH = python-with-ament-package;
  };

  meta = {
    description = "Tools for using Gazebo Sim simulation with ROS.";
    license = with lib.licenses; [ asl20 ];
  };
}
