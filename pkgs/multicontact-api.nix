{
  lib,
  fetchFromGitHub,
  stdenv,
  cmake,
  doxygen,
  jrl-cmakemodules,

  boost,
  ndcurves,
  pinocchio,
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

  nativeBuildInputs = [
    cmake
    doxygen
  ];
  buildInputs = [ jrl-cmakemodules ];

  propagatedBuildInputs = [
    boost
    ndcurves
    pinocchio
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_PYTHON_INTERFACE" false)
  ];

  doCheck = true;

  meta = {
    changelog = "https://github.com/loco-3d/multicontact-api/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "define, store and use ContactSequence objects";
    homepage = "https://github.com/loco-3d/multicontact-api";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.unix;
  };
})
