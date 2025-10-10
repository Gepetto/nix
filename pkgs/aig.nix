{
  lib,

  stdenv,
  fetchFromGitHub,

  # nativeBuildInputs
  cmake,

  # propagatedBuildInputs
  boost,
  eigen,
  eiquadprog,
  pinocchio,
  example-robot-data,
  jrl-cmakemodules,
  python3Packages,

  # checkInputs,
  # doctest,

  pythonSupport ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "aig";
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "Gepetto";
    repo = "aig";
    tag = "v${finalAttrs.version}";
    hash = "sha256-yrB+no9k63yFmy4a1Fgji6cOcLo81lf7Fc+QW6rOoD4=";
  };

  nativeBuildInputs = [
    cmake
  ];

  propagatedBuildInputs = [
    eigen
    eiquadprog
    jrl-cmakemodules
  ]
  ++ lib.optionals (!pythonSupport) [
    example-robot-data
    pinocchio
  ]
  ++ lib.optionals pythonSupport [
    python3Packages.boost
    python3Packages.eigenpy
    python3Packages.example-robot-data
    python3Packages.pinocchio
    python3Packages.pythonImportsCheckHook
  ];

  checkInputs = [
    boost
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_PYTHON_INTERFACE" pythonSupport)
  ];

  doCheck = true;
  pythonImportsCheck = [ "aig" ];

  meta = {
    description = "Analytical inverse geometry for 6 links kinematic chains";
    homepage = "https://github.com/Gepetto/aig";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.unix;
  };
})
