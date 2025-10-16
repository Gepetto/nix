{
  lib,

  buildPythonPackage,

  src-agimus-controller,

  # build-system,
  setuptools,

  # propagatedBuildInputs
  colmpc,
  crocoddyl,
  coal,
  example-robot-data,
  mim-solvers,
  pinocchio,
  rospkg,
}:

buildPythonPackage {
  pname = "agimus-controller";
  version = "0-unstable-2025-04-08";
  pyproject = true;

  src = src-agimus-controller;
  sourceRoot = "source/agimus_controller";

  build-system = [ setuptools ];
  propagatedBuildInputs = [
    # ament-index-python
    colmpc
    crocoddyl
    coal
    example-robot-data
    mim-solvers
    pinocchio
    rospkg
  ];

  doCheck = true;
  pythonImportsCheck = [ "agimus_controller" ];
  dontCheckRuntimeDeps = true;

  meta = {
    description = "The agimus_controller package";
    homepage = "https://github.com/agimus-project/agimus_controller";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.unix;
  };
}
