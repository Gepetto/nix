{
  lib,
  fetchFromGitHub,
  stdenv,
  jrl-cmakemodules,

  # nativeBuildInputs
  cmake,
  doxygen,

  # propagatedBuildInputs
  hpp-core,
  hpp-universal-robot,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-manipulation";
  version = "7.0.0";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-manipulation";
    # tag = "v${finalAttrs.version}";
    rev = "release/8.0.0";
    hash = "sha256-gGLd7GV6hkLMwbCrU7web9NHmwKNFoETb1IM3ynD8/4=";
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
    hpp-core
    hpp-universal-robot
  ];

  doCheck = true;

  meta = {
    description = "Classes for manipulation planning";
    homepage = "https://github.com/humanoid-path-planner/hpp-manipulation";
    changelog = "https://github.com/humanoid-path-planner/hpp-manipulation/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
