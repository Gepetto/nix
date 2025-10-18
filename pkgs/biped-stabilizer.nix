{
  lib,

  stdenv,
  fetchFromGitHub,

  # nativeBuildInputs
  cmake,

  # propagatedBuildInputs
  boost,
  eigen,
  jrl-cmakemodules,
  python3Packages,

  # checkInputs,
  doctest,

  pythonSupport ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "biped-stabilizer";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "Gepetto";
    repo = "biped-stabilizer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3LffArep/TA0gPu2DnXY2oXE9K6SuIAOM2cSYl3HBGE=";
  };

  nativeBuildInputs = [
    cmake
  ];

  propagatedBuildInputs = [
    eigen
    jrl-cmakemodules
  ]
  ++ lib.optionals (!pythonSupport) [
    boost
  ]
  ++ lib.optionals pythonSupport [
    python3Packages.boost
    python3Packages.eigenpy
    python3Packages.example-robot-data
    python3Packages.pinocchio
    python3Packages.pythonImportsCheckHook
  ];

  checkInputs = [
    doctest
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_PYTHON_INTERFACE" pythonSupport)
  ];

  doCheck = true;
  pythonImportsCheck = [ "biped_stabilizer" ];

  meta = {
    description = "Stabilizer for Biped Locomotion";
    homepage = "https://github.com/Gepetto/biped-stabilizer";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.unix;
  };
})
