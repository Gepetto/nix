{
  lib,

  buildPythonPackage,
  fetchFromGitHub,

  # nativeBuildInputs
  cmake,
  pkg-config,
  pythonImportsCheckHook,

  # propagatedBuildInputs
  pinocchio,
  pyyaml,
  toolbox-parallel-robots,
}:

buildPythonPackage rec {
  pname = "example-parallel-robots";
  version = "1.0.0";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "Gepetto";
    repo = "example-parallel-robots";
    tag = "v${version}";
    hash = "sha256-AXkbA+j7w5n+zSgDLHCXkkYgV2utR259P1B4O/Th62I=";
  };

  cmakeFlags = [
    (lib.cmakeBool "BUILD_PYTHON_INTERFACE" true)
    (lib.cmakeBool "BUILD_TESTING" true)
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    pythonImportsCheckHook
  ];
  propagatedBuildInputs = [
    pinocchio
    pyyaml
    toolbox-parallel-robots
  ];

  # TODO: segfault ? :/
  # preInstallCheck = ''
  #   cmake --build . -t test
  # '';
  pythonImportsCheck = [ "example_parallel_robots" ];

  meta = {
    description = "Set of parallel robot models for general use in benchmarks and examples";
    homepage = "https://github.com/Gepetto/example-parallel-robots";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.unix;
  };
}
