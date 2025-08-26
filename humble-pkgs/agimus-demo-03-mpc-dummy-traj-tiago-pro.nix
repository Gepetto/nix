{
  lib,
  buildRosPackage,
  fetchFromGitHub,
  python-with-ament-package,

  # nativeBuildInputs
  ament-cmake-auto,

  # propagatedBuildInputs
  agimus-demos-common,
  ros2launch,

# checkInputs
}:
buildRosPackage rec {
  pname = "ros-humble-agimus-demo-03-mpc-dummy-traj-tiago-pro";
  version = "0.0.0";

  src = fetchFromGitHub {
    owner = "agimus-project";
    repo = "agimus-demos";
    rev = "11f3641d1f5154d55c5af34d1f54d606adc6f830";
    hash = "sha256-geE90nIryyG18V09f/W/nzvOexiQW7XkW6ZTeRMAcUg=";
  };
  sourceRoot = "source/agimus_demo_03_mpc_dummy_traj_tiago_pro";

  buildType = "ament_cmake";

  nativeBuildInputs = [
    ament-cmake-auto
  ];
  propagatedBuildInputs = [
    agimus-demos-common
    ros2launch
  ];
  checkInputs = [
  ];

  env.PYTHONPATH = python-with-ament-package;

  doCheck = true;

  meta = {
    description = "agimus_demo_03_mpc_dummy_traj_tiago_pro contains the entry points for a simple TIAGo pal-robotics
    demo with the LFC and an MPC following a dummy trajectory.";
    license = with lib.licenses; [ unfree ];
    homepage = "https://github.com/agimus-project/agimus-demos";
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.nim65s ];
  };
}
