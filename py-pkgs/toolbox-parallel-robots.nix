{
  lib,

  buildPythonPackage,
  fetchFromGitHub,
  python,

  # nativeBuildInputs
  cmake,
  pkg-config,
  pythonImportsCheckHook,

  # propagatedBuildInputs
  pinocchio,
  qpsolvers,
  scipy,
}:

buildPythonPackage rec {
  pname = "toolbox-parallel-robots";
  version = "1.2.0";
  pyproject = false;

  src = fetchFromGitHub {
    owner = "gepetto";
    repo = "toolbox-parallel-robots";
    tag = "v${version}";
    hash = "sha256-tFMKVhBhA3zXEt4Yb8btI0LYc84SndpgfMsJSUlLL48=";
  };

  cmakeFlags = [
    # Not sure why jrl-cmakemodule fail to set this here
    (lib.cmakeFeature "PYTHON_SITELIB" python.sitePackages)
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    pythonImportsCheckHook
  ];
  propagatedBuildInputs = [
    pinocchio
    qpsolvers
    scipy
  ];

  doCheck = true;
  pythonImportsCheck = [ "toolbox_parallel_robots" ];

  meta = {
    description = "Set of tools to work with robots with bilateral constraints";
    homepage = "https://github.com/gepetto/toolbox-parallel-robots";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.unix;
  };
}
