{
  lib,
  buildRosPackage,
  fetchFromGitHub,
  python-with-ament-package,

  # nativeBuildInputs

  # propagatedBuildInputs
  agimus-demo-00-franka-controller,
  agimus-demo-01-lfc-alone,
  agimus-demo-02-simple-pd-plus,
  agimus-demo-02-simple-pd-plus-tiago-pro,
  agimus-demo-03-mpc-dummy-traj,
  agimus-demo-03-mpc-dummy-traj-tiago-pro,
  agimus-demo-05-pick-and-place,
  agimus-demos-common,

# checkInputs
}:
buildRosPackage rec {
  pname = "ros-humble-agimus-demos";
  version = "0.0.0";

  src = fetchFromGitHub {
    owner = "agimus-project";
    repo = "agimus-demos";
    rev = "11f3641d1f5154d55c5af34d1f54d606adc6f830";
    hash = "sha256-geE90nIryyG18V09f/W/nzvOexiQW7XkW6ZTeRMAcUg=";
  };
  sourceRoot = "source/agimus_demos";

  buildType = "ament_cmake";

  nativeBuildInputs = [
  ];
  propagatedBuildInputs = [
    agimus-demo-00-franka-controller
    agimus-demo-01-lfc-alone
    agimus-demo-02-simple-pd-plus
    agimus-demo-02-simple-pd-plus-tiago-pro
    agimus-demo-03-mpc-dummy-traj
    agimus-demo-03-mpc-dummy-traj-tiago-pro
    agimus-demo-05-pick-and-place
    agimus-demos-common
  ];
  checkInputs = [
  ];

  env.PYTHONPATH = python-with-ament-package;

  doCheck = true;

  meta = {
    description = "A package to aggregate all packages in agimus_demos.";
    license = with lib.licenses; [ unfree ];
    homepage = "https://github.com/agimus-project/agimus-demos";
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.nim65s ];
  };
}
