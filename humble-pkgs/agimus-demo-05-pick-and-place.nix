{
  lib,
  buildRosPackage,
  fetchFromGitHub,
  python-with-ament-package,

  # nativeBuildInputs
  ament-cmake-auto,
  ament-lint-auto,

  # propagatedBuildInputs
  agimus-demos-common,
  python3Packages,
  linear-feedback-controller,
  ros2launch,
  xterm,

# checkInputs
}:
buildRosPackage rec {
  pname = "ros-humble-agimus-demo-05-pick-and-place";
  version = "0.0.0";

  src = fetchFromGitHub {
    owner = "agimus-project";
    repo = "agimus-demos";
    rev = "11f3641d1f5154d55c5af34d1f54d606adc6f830";
    hash = "sha256-geE90nIryyG18V09f/W/nzvOexiQW7XkW6ZTeRMAcUg=";
  };
  sourceRoot = "source/agimus_demo_05_pick_and_place";

  buildType = "ament_cmake";

  nativeBuildInputs = [
    ament-cmake-auto
    ament-lint-auto
  ];
  propagatedBuildInputs = [
    agimus-demos-common
    linear-feedback-controller
    python3Packages.ipython
    ros2launch
    xterm
  ];
  checkInputs = [
  ];

  env.PYTHONPATH = python-with-ament-package;

  doCheck = true;

  meta = {
    description = "The purpose of this demo is to use the AGIMUS architecture to unbox some objects.";
    license = with lib.licenses; [ unfree ];
    homepage = "https://github.com/agimus-project/agimus-demos";
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.nim65s ];
  };
}
