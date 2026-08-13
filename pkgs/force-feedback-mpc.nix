{
  lib,
  stdenv,
  fetchFromGitHub,
  jrl-cmakemodules,

  eigen,
  llvmPackages,
  pinocchio,
  crocoddyl,
  boost,
  nix-update-script,
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

  nativeBuildInputs = jrl-cmakemodules.docsNativeBuildInputs;

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

  cmakeFlags = jrl-cmakemodules.docsCmakeFlags ++ [
    (lib.cmakeBool "BUILD_PYTHON_INTERFACE" false)
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.doCheck)
  ];

  doCheck = true;

  strictDeps = true;
  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/machines-in-motion/force_feedback_mpc/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Optimal control tools to achieve force feedback in MPC.";
    homepage = "https://github.com/machines-in-motion/force_feedback_mpc/";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.unix;
  };
})
