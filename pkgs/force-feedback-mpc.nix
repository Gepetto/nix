{
  lib,

  stdenv,
  fetchFromGitHub,

  # nativeBuildInputs
  cmake,

  # propagatedBuildInputs
  eigen,
  jrl-cmakemodules,
  python3Packages,

  # checkInputs
  doctest,

  pythonSupport ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "force-feedback-mpc";
  version = "0.0.0-unstable-2025-12-01";

  src = fetchFromGitHub {
    owner = "machines-in-motion";
    repo = "force_feedback_mpc";
    rev = "04bd43213bc47facd0b752f987fbbdfd3aa5a165";
    hash = lib.fakeHash;
  };

  nativeBuildInputs = [
    cmake
  ];

  propagatedBuildInputs = [
    eigen
    jrl-cmakemodules
    llvmPackages.openmp
  ]
  ++ lib.optionals !pythonSupport [
    
  ]
  ++ lib.optionals pythonSupport [
    python3Packages.boost
    python3Packages.eigenpy
    python3Packages.pinocchio
    python3Packages.crocoddyl
    python3Packages.pythonImportsCheckHook
  ];

  checkInputs = [ ]
  ++ lib.optionals !pythonSupport [
    ctest
    boost
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_PYTHON_INTERFACE" pythonSupport)
  ];

  doCheck = true;
  pythonImportsCheck = [ "machines-in-motion" ];

  meta = {
    description = "Optimal control tools to achieve force feedback in MPC.";
    homepage = "https://github.com/machines-in-motion/force_feedback_mpc/";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.unix;
  };
})
