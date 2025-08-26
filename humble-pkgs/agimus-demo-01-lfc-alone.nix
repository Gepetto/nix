{
  lib,
  buildRosPackage,
  fetchFromGitHub,

  # nativeBuildInputs
  ament-cmake-auto,
  ament-lint-auto,

  # propagatedBuildInputs
  controller-interface,
  eigen3-cmake-module,
  hardware-interface,
  linear-feedback-controller,
  linear-feedback-controller-msgs,
  pinocchio,
  pluginlib,
  realtime-tools,
  ros2launch,

# checkInputs
}:
buildRosPackage rec {
  pname = "ros-humble-agimus-demo-01-lfc-alone";
  version = "0.0.0";

  src = fetchFromGitHub {
    owner = "agimus-project";
    repo = "agimus-demos";
    rev = "11f3641d1f5154d55c5af34d1f54d606adc6f830";
    hash = "sha256-geE90nIryyG18V09f/W/nzvOexiQW7XkW6ZTeRMAcUg=";
  };
  sourceRoot = "source/agimus_demo_01_lfc_alone";

  buildType = "ament_cmake";

  nativeBuildInputs = [
    ament-cmake-auto
    ament-lint-auto
  ];
  propagatedBuildInputs = [
    controller-interface
    eigen3-cmake-module
    hardware-interface
    linear-feedback-controller
    linear-feedback-controller-msgs
    pinocchio
    pluginlib
    realtime-tools
    ros2launch
  ];
  checkInputs = [
  ];

  doCheck = true;

  meta = {
    description = "agimus_demo_01_lfc_alone contains the entry points for a simple Panda demo with the LFC";
    license = with lib.licenses; [ unfree ];
    homepage = "https://github.com/agimus-project/agimus-demos";
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.nim65s ];
  };
}
