{
  lib,

  buildPythonPackage,

  src-agimus-controller,

  # nativeBuildInputs
  pythonImportsCheckHook,

  # propagatedBuildInputs
  python3Packages
}:

buildPythonPackage {
  pname = "agimus-controller";
  version = "0-unstable-2025-04-08";
  pyproject = false;

  src = src-agimus-controller;

  nativeBuildInputs = [
    pythonImportsCheckHook
  ];
  propagatedBuildInputs = [
    python3Packages.colmpc
    python3Packages.crocoddyl
    python3Packages.coal
    python3Packages.example-robot-data
    python3Packages.mim-solvers
    python3Packages.numpy
    python3Packages.pinocchio
    python3Packages.rospkg

    franka-description
    xacro
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
