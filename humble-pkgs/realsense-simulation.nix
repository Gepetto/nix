{
  lib,
  buildRosPackage,
  fetchFromGitHub,

  # nativeBuildInputs
  ament-cmake-auto,

  # propagatedBuildInputs
  realsense-gazebo-plugin,
  xacro,

  # checkInputs
  ament-lint-auto,
  ament-lint-common,
}:
buildRosPackage rec {
  pname = "ros-humble-realsense-simulation";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "pal-robotics";
    repo = "realsense_simulation";
    tag = version;
    hash = "sha256-Ug5VZLKR+eGfkwJDQa26+REj0IuURQ5l7U9NZJTnpOY=";
  };
  sourceRoot = "source/";

  buildType = "ament_cmake";

  nativeBuildInputs = [
    ament-cmake-auto
  ];
  propagatedBuildInputs = [
    realsense-gazebo-plugin
    xacro
  ];
  checkInputs = [
    ament-lint-auto
    ament-lint-common
  ];

  doCheck = false;

  meta = {
    description = "RealSense Camera description package for simulation";
    license = with lib.licenses; [ unfree ];
    homepage = "https://github.com/pal-robotics/realsense_simulation";
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.nim65s ];
  };
}
