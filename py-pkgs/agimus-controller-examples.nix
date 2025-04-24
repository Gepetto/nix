{
  lib,

  buildPythonPackage,

  src-agimus-controller,

  # nativeBuildInputs
  pythonImportsCheckHook,

  # propagatedBuildInputs
  python3Packages,
}:

buildPythonPackage {
  pname = "agimus-controller-examples";
  version = "0-unstable-2025-04-08";

  src = src-agimus-controller;
  sourceRoot = "${src.name}/agimus_controller_examples";

  nativeBuildInputs = [
    python3Packages.franka-description
    python3Packages.xacro
    pythonImportsCheckHook
  ];
  propagatedBuildInputs = [
    python3Packages.agimus-controller
    python3Packages.hpp-corbaserver
    python3Packages.hpp-gepetto-viewer
    python3Packages.hpp-manipulation-corba
    python3Packages.meshcat
    python3Packages.matplotlib
    python3Packages.numpy
    python3Packages.ament-index-python
  ];

  doCheck = true;
  pythonImportsCheck = [ "agimus_controller" ];

  meta = {
    description = "Examples of usage of the agimus_controller package.";
    homepage = "https://github.com/agimus-project/agimus_controller";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.linux;
  };
}
