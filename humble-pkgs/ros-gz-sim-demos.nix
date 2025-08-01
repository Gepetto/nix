# Copyright 2025 Open Source Robotics Foundation
# Distributed under the terms of the BSD license

{
  lib,
  buildRosPackage,
  fetchurl,
  ament-cmake,
  ament-lint-auto,
  ament-lint-common,
  ament-package,
  ignition,
  image-transport-plugins,
  robot-state-publisher,
  ros-gz-bridge,
  ros-gz-image,
  ros-gz-sim,
  rqt-image-view,
  rqt-plot,
  rqt-topic,
  rviz2,
  sdformat-urdf,
  xacro,
  python-with-ament-package,
}:
buildRosPackage {
  pname = "ros-humble-ros-gz-sim-demos";
  version = "0.244.20-r1";

  src = fetchurl {
    url = "https://github.com/ros2-gbp/ros_ign-release/archive/release/humble/ros_gz_sim_demos/0.244.20-1.tar.gz";
    name = "0.244.20-1.tar.gz";
    hash = "sha256-PUJ9kkkYanmLO3FTABEIczjbzQIAxGc24yM28j4W5H8=";
  };

  buildType = "ament_cmake";
  buildInputs = [ ament-cmake ];
  checkInputs = [
    ament-lint-auto
    ament-lint-common
  ];
  propagatedBuildInputs = [
    ament-package
    ignition.sim8
    image-transport-plugins
    robot-state-publisher
    ros-gz-bridge
    ros-gz-image
    ros-gz-sim
    rqt-image-view
    rqt-plot
    rqt-topic
    rviz2
    sdformat-urdf
    xacro
  ];
  nativeBuildInputs = [
    ament-cmake
  ];
  env.PYTHONPATH = python-with-ament-package;

  meta = {
    description = "Demos using Gazebo Sim simulation with ROS.";
    license = with lib.licenses; [ asl20 ];
  };
}
