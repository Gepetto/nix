{
  lib,

  buildPythonPackage,

  src-agimus-controller,

  # nativeBuildInputs
  pythonImportsCheckHook,

  # propagatedBuildInputs
  colmpc
  crocoddyl
  coal
  example-robot-data
  mim-solvers
  numpy
  pinocchio
  rospkg

  # None python inputs
  franka-description
  xacro
  ament-index-python,
}:

buildPythonPackage {
  pname = "agimus-controller";
  version = "0-unstable-2025-04-08";

  src = src-agimus-controller;
  sourceRoot = "${src.name}/agimus_controller";

  nativeBuildInputs = [
    pythonImportsCheckHook
    franka-description
    xacro
  ];
  propagatedBuildInputs = [
    colmpc
    crocoddyl
    coal
    example-robot-data
    mim-solvers
    numpy
    pinocchio
    rospkg
    ament-index-python
  ];

  doCheck = true;
  pythonImportsCheck = [ "agimus_controller" ];

  meta = {
    description = "The agimus_controller package";
    homepage = "https://github.com/agimus-project/agimus_controller";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.linux;
  };
}
