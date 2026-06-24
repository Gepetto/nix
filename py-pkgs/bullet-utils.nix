{
  lib,

  buildPythonPackage,

  src-agimus-controller,

  # nativeBuildInputs
  pythonImportsCheckHook,

  # propagatedBuildInputs
  colmpc,
  crocoddyl,
  coal,
  example-robot-data,
  mim-solvers,
  numpy,
  pinocchio,
  rospkg,
}:

buildPythonPackage {
  pname = "bullet-utils";
  version = "";

  src = src-agimus-controller;
  sourceRoot = "source/agimus_controller";

  nativeBuildInputs = [
    pythonImportsCheckHook
    # franka-description
    # xacro
  ];
  propagatedBuildInputs = [
    # ament-index-python
    colmpc
    crocoddyl
    coal
    example-robot-data
    mim-solvers
    numpy
    pinocchio
    rospkg
  ];

  doCheck = true;
  pythonImportsCheck = [ "agimus_controller" ];

  meta = {
    description = "The agimus_controller package";
    homepage = "https://github.com/agimus-project/agimus_controller";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.unix;
  };
}
