{
  lib,
  fetchFromGitHub,
  stdenv,

  # nativeBuildInputs
  cmake,
  doxygen,

  # propagatedBuildInputs
  coal,
  jrl-cmakemodules,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-affordance";
  version = "7.0.0";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-affordance";
    # tag = "v${finalAttrs.version}";
    rev = "release/8.0.0";
    hash = "sha256-oZvU0RGiZAW/yDxAcMphJQcfW1SIrXgLYWPD6xKczyc=";
  };

  outputs = [
    "out"
    "doc"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    doxygen
  ];

  buildInputs = [ jrl-cmakemodules ];

  propagatedBuildInputs = [
    coal
  ];
  doxytagsDeps = [ coal.doc ];

  meta = {
    description = "Implements affordance extraction for multi-contact planning";
    homepage = "https://github.com/humanoid-path-planner/hpp-affordance";
    changelog = "https://github.com/humanoid-path-planner/hpp-affordance/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
