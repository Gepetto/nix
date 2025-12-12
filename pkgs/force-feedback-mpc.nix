{
  lib,

  stdenv,
  fetchFromGitHub,

  # nativeBuildInputs
  cmake,
  pkg-config,

  # propagatedBuildInputs
  eigen,
  jrl-cmakemodules,
  llvmPackages,
  pinocchio,
  crocoddyl,
  boost,
}:

stdenv.mkDerivation (_finalAttrs: {
  pname = "force-feedback-mpc";
  version = "0.0.0-unstable-2025-12-01";

  src = fetchFromGitHub {
    owner = "machines-in-motion";
    repo = "force_feedback_mpc";
    rev = "c458fcdc86bf944aca53ab677e7964b85ac5fd40";
    hash = "sha256-w5mW33EfD0H1euhG9k0PHAcL0yu8qS1grQJVUTkY6Bw=";
  };

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  propagatedBuildInputs = [
    eigen
    jrl-cmakemodules
    pinocchio
    crocoddyl
  ]
  ++ lib.optional stdenv.cc.isClang llvmPackages.openmp;

  checkInputs = [
    boost
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_PYTHON_INTERFACE" false)
  ];

  doCheck = true;

  meta = {
    description = "Optimal control tools to achieve force feedback in MPC.";
    homepage = "https://github.com/machines-in-motion/force_feedback_mpc/";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.unix;
  };
})
