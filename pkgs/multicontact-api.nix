{
  lib,
  fetchFromGitHub,
  stdenv,
  jrl-cmakemodules,

  boost,
  ndcurves,
  pinocchio,

  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "multicontact-api";
  version = "4.2.1";

  src = fetchFromGitHub {
    owner = "loco-3d";
    repo = "multicontact-api";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ICcS/jmtH/DjBsYMGrOZxyxbrxOYSR+uxc6SeycP2o4=";
  };

  outputs = [
    "out"
    "doc"
  ];

  nativeBuildInputs = jrl-cmakemodules.docsNativeBuildInputs;

  buildInputs = [
    jrl-cmakemodules
  ];

  propagatedBuildInputs = [
    boost
    ndcurves
    pinocchio
  ];

  cmakeFlags = jrl-cmakemodules.docsCmakeFlags ++ [
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.doCheck)
    (lib.cmakeBool "BUILD_PYTHON_INTERFACE" false)
  ];

  doCheck = true;

  strictDeps = true;
  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/loco-3d/multicontact-api/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "define, store and use ContactSequence objects";
    homepage = "https://github.com/loco-3d/multicontact-api";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.unix;
  };
})
