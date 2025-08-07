{
  lib,
  buildRosPackage,
  fetchFromGitHub,

  # nativeBuildInputs
  ament-cmake,

  # propagatedBuildInputs
  pal-pro-gripper-controller-configuration,
  pal-pro-gripper-description,

# checkInputs
}:
buildRosPackage rec {
  pname = "ros-humble-pal-pro-gripper";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "pal-robotics";
    repo = "pal_pro_gripper";
    tag = version;
    hash = "sha256-3iYiBdAlo3DBap2HRK3GcrYnGAEWHyfYpK2+ck0AgPU=";
  };
  sourceRoot = "source/pal_pro_gripper";

  buildType = "ament_cmake";

  nativeBuildInputs = [
    ament-cmake
  ];
  propagatedBuildInputs = [
    pal-pro-gripper-controller-configuration
    pal-pro-gripper-description
  ];
  checkInputs = [
  ];

  doCheck = true;

  meta = {
    description = "The pal_pro_gripper package";
    license = with lib.licenses; [ asl20 ];
    homepage = "https://github.com/pal-robotics/pal_pro_gripper";
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.nim65s ];
  };
}
