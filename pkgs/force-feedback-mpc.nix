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

  src = /home/mnaveau/devel/workspace_gepetto_nix/force_feedback_mpc;
  
  # src = fetchFromGitHub {
  #   owner = "machines-in-motion";
  #   repo = "force_feedback_mpc";
  #   rev = "69a554f824002474490668c8620cf8414a34d8b4";
  #   # hash = lib.fakeHash;
  #   hash = "sha256-fOINGdngTqGcE1CiymUvXT/QyRnAE9tydM7b1dN+kBk=";
  # };

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  propagatedBuildInputs = [
    eigen
    jrl-cmakemodules
    llvmPackages.openmp
    pinocchio
    crocoddyl
  ];

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
