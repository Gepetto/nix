{
  lib,
  buildRosPackage,
  fetchFromGitHub,

  # nativeBuildInputs
  ament-cmake,

  # propagatedBuildInputs
  tiago-pro-head-bringup,
  tiago-pro-head-controller-configuration,
  tiago-pro-head-description,

# checkInputs
}:
buildRosPackage rec {
  pname = "ros-humble-tiago-pro-head-robot";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "pal-robotics";
    repo = "tiago_pro_head_robot";
    tag = version;
    hash = "sha256-XEUlNiuaDBIBSGRbaEB6WTf7YgCcEp2RBp3XjO2uUPE=";
  };
  sourceRoot = "source/tiago_pro_head_robot";

  buildType = "ament_cmake";

  nativeBuildInputs = [
    ament-cmake
  ];
  propagatedBuildInputs = [
    tiago-pro-head-bringup
    tiago-pro-head-controller-configuration
    tiago-pro-head-description
  ];
  checkInputs = [
  ];

  doCheck = true;

  meta = {
    description = "The tiago_pro_head_robot package";
    license = with lib.licenses; [ asl20 ];
    homepage = "https://github.com/pal-robotics/tiago_pro_head_robot";
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.nim65s ];
  };
}
