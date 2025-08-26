{
  lib,
  buildRosPackage,
  fetchFromGitHub,

  # nativeBuildInputs
  ament-cmake,

# propagatedBuildInputs

# checkInputs
}:
buildRosPackage rec {
  pname = "ros-humble-net-ft-description";
  version = "0.0.0";

  src = fetchFromGitHub {
    owner = "gbartyzel";
    repo = "ros2_net_ft_driver";
    rev = "393960c20c1607bbdeec7bff70ce5b4db01e3ab3";
    hash = "sha256-TbTs7PmP98WyCIslfgdh+TLHi8jZZXgjEiHoFnIQXZw=";
  };
  sourceRoot = "source/net_ft_description";

  buildType = "ament_cmake";

  nativeBuildInputs = [
    ament-cmake
  ];
  propagatedBuildInputs = [
  ];
  checkInputs = [
  ];

  doCheck = true;

  meta = {
    description = "URDF description for F/T sensors";
    license = with lib.licenses; [ unfree ];
    homepage = "https://github.com/gbartyzel/ros2_net_ft_driver";
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.nim65s ];
  };
}
