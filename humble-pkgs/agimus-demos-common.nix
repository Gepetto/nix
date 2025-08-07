{
  lib,
  buildRosPackage,
  fetchFromGitHub,

  # nativeBuildInputs
  ament-cmake-auto,
  ament-cmake-python,

  # propagatedBuildInputs
  controller-manager,
  franka-description,
  franka-gripper,
  franka-hardware,
  franka-ign-ros2-control,
  franka-robot-state-broadcaster,
  gripper-controllers,
  joint-state-broadcaster,
  joint-state-publisher,
  linear-feedback-controller,
  linear-feedback-controller-msgs,
  net-ft-description,
  net-ft-diagnostic-broadcaster,
  net-ft-driver,
  python3Packages,
  python-with-ament-package,
  robot-state-publisher,
  ros-gz-bridge,
  ros-gz-sim,
  ros2launch,
  rviz2,
  tiago-pro-description,
  tiago-pro-gazebo,
  xacro,

# checkInputs
}:
buildRosPackage rec {
  pname = "ros-humble-agimus-demos-common";
  version = "0.0.0";

  src = fetchFromGitHub {
    owner = "agimus-project";
    repo = "agimus-demos";
    rev = "11f3641d1f5154d55c5af34d1f54d606adc6f830";
    hash = "sha256-geE90nIryyG18V09f/W/nzvOexiQW7XkW6ZTeRMAcUg=";
  };
  sourceRoot = "source/agimus_demos_common";

  buildType = "ament_cmake";

  nativeBuildInputs = [
    ament-cmake-auto
    ament-cmake-python
  ];
  propagatedBuildInputs = [
    controller-manager
    franka-description
    franka-gripper
    franka-hardware
    franka-ign-ros2-control
    franka-robot-state-broadcaster
    gripper-controllers
    joint-state-broadcaster
    joint-state-publisher
    linear-feedback-controller
    linear-feedback-controller-msgs
    net-ft-description
    net-ft-diagnostic-broadcaster
    net-ft-driver
    python3Packages.jinja2
    robot-state-publisher
    ros-gz-bridge
    ros-gz-sim
    ros2launch
    rviz2
    tiago-pro-description
    tiago-pro-gazebo
    xacro
  ];
  checkInputs = [
  ];

  env.PYTHONPATH = python-with-ament-package;

  doCheck = true;

  meta = {
    description = "Common launch and config files used across all demos created for Agimus Project.";
    license = with lib.licenses; [ unfree ];
    homepage = "https://github.com/agimus-project/agimus-demos";
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.nim65s ];
  };
}
