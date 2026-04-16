{
  lib,
  fetchFromGitHub,
  stdenv,
  jrl-cmakemodules,

  pythonSupport ? false,
  python3Packages,

  # nativeBuildInputs
  cmake,
  doxygen,

  # buildInputs
  cddlib,
  clp,
  qpoases,

  # propagatedBuildInputs
  boost,
  eigen,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-centroidal-dynamics";
  version = "8.0.0";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-centroidal-dynamics";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/tK7tBzhmuNl2zqWpONDv0f9AZGkIaOHNDBodGzo9lY=";
  };

  outputs = [
    "out"
    "doc"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    doxygen
  ]
  ++ lib.optionals pythonSupport [
    python3Packages.python
    python3Packages.pythonImportsCheckHook
  ];

  buildInputs = [
    cddlib
    clp
    jrl-cmakemodules
    qpoases
  ];

  propagatedBuildInputs = [
    eigen
  ]
  ++ lib.optionals pythonSupport [
    python3Packages.boost
    python3Packages.eigenpy
  ]
  ++ lib.optional (!pythonSupport) boost;

  cmakeFlags = [
    (lib.cmakeBool "BUILD_PYTHON_INTERFACE" pythonSupport)
    (lib.cmakeBool "BUILD_WITH_CLP" true)
  ];

  doCheck = true;

  pythonImportsCheck = [ "hpp_centroidal_dynamics" ];

  meta = {
    description = "Utility classes to check the (robust) equilibrium of a system in contact with the environment.";
    homepage = "https://github.com/humanoid-path-planner/hpp-centroidal-dynamics";
    changelog = "https://github.com/humanoid-path-planner/hpp-centroidal-dynamics/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
