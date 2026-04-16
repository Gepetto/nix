{
  lib,
  fetchFromGitHub,
  buildPythonPackage,

  # buildInputs
  boost,

  # nativeBuildInputs
  cmake,
  doxygen,
  pkg-config,

  # propagatedBuildInputs
  eigenpy,
  jrl-cmakemodules,
  pinocchio,
  hpp-util,
  hpp-pinocchio,
  hpp-constraints,
  hpp-core,
  hpp-corbaserver,
  hpp-manipulation,
  hpp-manipulation-urdf,

  # dependencies
  lxml,

  # installCheckInputs
  pkgs,
}:

buildPythonPackage rec {
  pname = "hpp-python";
  version = "7.0.0";
  pyproject = false; # built with CMake

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-python";
    # tag = "v${version}";
    rev = "release/8.0.0";
    hash = "sha256-ScxIKdOHu1qBzZo+seTF8IKe8ha1gYKU1lMBj+7KFyo=";
  };

  prePatch = ''
    patchShebangs doc/configure.py
  '';

  outputs = [
    "out"
    "doc"
  ];

  strictDeps = true;

  buildInputs = [
    boost
  ];

  nativeBuildInputs = [
    cmake
    doxygen
    pkg-config
  ];

  propagatedBuildInputs = [
    eigenpy
    jrl-cmakemodules
    pinocchio
    hpp-util
    hpp-pinocchio
    hpp-constraints
    hpp-core
    hpp-corbaserver
    hpp-manipulation
    hpp-manipulation-urdf
    lxml
  ];

  installCheckInputs = [
    pkgs.example-robot-data
    pkgs.hpp-environments
  ];

  pythonImportsCheck = [
    "pyhpp"
  ];

  meta = {
    homepage = "https://github.com/humanoid-path-planner/hpp-python/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.linux; # TODO: macos
  };
}
