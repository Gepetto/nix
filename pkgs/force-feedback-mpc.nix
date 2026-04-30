{
  lib,
  stdenv,
  fetchFromGitHub,
  jrl-cmakemodules,

  cmake,
  doxygen,
  eigen,
  llvmPackages,
  pinocchio,
  pkg-config,
  crocoddyl,
  boost,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "force-feedback-mpc";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "machines-in-motion";
    repo = "force_feedback_mpc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-J1LBENg/AbxR8+TEe1TzQ2rbIx8ojyQPGSeatosYAkU=";
  };

  nativeBuildInputs = [
    cmake
    doxygen
    pkg-config
  ];

  buildInputs = [ jrl-cmakemodules ];

  propagatedBuildInputs = [
    eigen
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
    changelog = "https://github.com/machines-in-motion/force_feedback_mpc/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Optimal control tools to achieve force feedback in MPC.";
    homepage = "https://github.com/machines-in-motion/force_feedback_mpc/";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.unix;
  };
})
