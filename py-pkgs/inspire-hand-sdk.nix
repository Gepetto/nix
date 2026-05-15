{
  lib,

  buildPythonPackage,
  fetchFromGitHub,

  setuptools,
  cyclonedds-python_10,
  numpy,
  pyqt5,
  pyqtgraph,
  colorcet,
  pymodbus_369,
  pyserial,
  unitree-sdk2-python,
}:
buildPythonPackage (finalAttrs: {
  name = "inspire-hand-sdk";
  version = "0-unstable-2026-05-07";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "NaCl-1374";
    repo = "inspire_hand_ws";
    rev = "fc754900caaaa82c9b59fb12c1b79ebfd1c1a0e7";
    hash = "sha256-w6f2bEs6va9BprFGjQzQddoRYV5VRdGwdX4cjo5iC5o=";
  };
  sourceRoot = "${finalAttrs.src.name}/inspire_hand_sdk";

  build-system = [ setuptools ];
  dependencies = [
    cyclonedds-python_10
    numpy
    pyqt5
    pyqtgraph
    colorcet
    pymodbus_369
    pyserial
    unitree-sdk2-python
  ];

  pythonRelaxDeps = [ "pymodbus" ];
  pythonImportsCheck = [ "inspire_sdkpy" ];

  meta = {
    description = "Inspire Hand sdk for python";
    homepage = "https://github.com/NaCl-1374/inspire_hand_ws";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nim65s ];
    mainProgram = "inspire-hand-ws";
    platforms = lib.platforms.all;
  };
})
