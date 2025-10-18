{
  lib,

  buildPythonPackage,

  src-agimus-controller,

  # build-system,
  setuptools,

  # dependencies
  agimus-controller,
  hpp-corbaserver,
  hpp-gepetto-viewer,
  hpp-manipulation-corba,
  meshcat,
  matplotlib,
  numpy,
# ament-index-python
# franka-description
# xacro
}:

buildPythonPackage {
  pname = "agimus-controller-examples";
  version = "0-unstable-2025-04-08";
  pyproject = true;

  src = src-agimus-controller;
  sourceRoot = "source/agimus_controller_examples";

  build-system = [ setuptools ];
  dependencies = [
    agimus-controller
    hpp-corbaserver
    hpp-gepetto-viewer
    hpp-manipulation-corba
    meshcat
    matplotlib
    numpy
    # ament-index-python
  ];

  doCheck = true;
  pythonImportsCheck = [ "agimus_controller" ];

  meta = {
    description = "Examples of usage of the agimus_controller package.";
    homepage = "https://github.com/agimus-project/agimus_controller";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.unix;
  };
}
