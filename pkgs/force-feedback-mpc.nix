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
  python3Packages,
  llvmPackages,
  pinocchio,
  crocoddyl,
  boost,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "force-feedback-mpc";
  version = "0.0.0-unstable-2025-12-01";

  src = fetchFromGitHub {
    # Until https://github.com/machines-in-motion/force_feedback_mpc/pull/5 is merged
    # owner = "machines-in-motion";
    owner = "MaximilienNaveau";
    repo = "force_feedback_mpc";
    rev = "d94e280b204755589192d6c184a231eb0579ca1a";
    hash = "sha256-hcULNgLIfkCabFdEmfqF1genEfQzIJY6nsx5WxqOeFA=";
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
  ] ++ lib.optional stdenv.cc.isClang llvmPackages.openmp;

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
