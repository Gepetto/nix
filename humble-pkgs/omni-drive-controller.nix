{
  lib,
  buildRosPackage,
  fetchFromGitHub,

  # nativeBuildInputs
  ament-cmake,

  # propagatedBuildInputs

  # checkInputs
  ament-lint-auto,
  ament-lint-common,
}:
buildRosPackage rec {
  pname = "ros-humble-omni-drive-controller";
  version = "0.0.0";

  src = fetchFromGitHub {
    owner = "jpgtzg";
    repo = "omni_drive_controller";
    rev = "842b49a9562433ca14ecb02c83eecded0fb9047a";
    hash = "sha256-9IaZ3XtdWD0SeHlHR4tDBmRXOnXKe7gRK3sc7k8Csp0=";
  };
  sourceRoot = "source/";

  buildType = "ament_cmake";

  nativeBuildInputs = [
    ament-cmake
  ];
  propagatedBuildInputs = [
  ];
  checkInputs = [
    ament-lint-auto
    ament-lint-common
  ];

  doCheck = false;

  meta = {
    description = "TODO: Package description";
    license = with lib.licenses; [ unfree ];
    homepage = "https://github.com/jpgtzg/omni_drive_controller";
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.nim65s ];
  };
}
