{
  lib,
  fetchFromGitHub,
  stdenv,
  jrl-cmakemodules,

  # nativeBuildInputs
  cmake,
  doxygen,

  # propagatedBuildInputs
  example-robot-data,
  hpp-environments,
  hpp-util,
  pinocchio,

  # doc
  coal,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-pinocchio";
  version = "8.0.0";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-pinocchio";
    tag = "v${finalAttrs.version}";
    hash = "sha256-24S1Gg2LYWz3c6XeOK0WClIsqRfcp6Q1to3dy1Zu2i0=";
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
    example-robot-data
    hpp-environments
    hpp-util
    pinocchio
  ];

  doxytagsDeps = [
    coal.doc
    pinocchio.doc
  ];

  doCheck = true;

  meta = {
    description = "Wrapping of Pinocchio library into HPP";
    homepage = "https://github.com/humanoid-path-planner/hpp-pinocchio";
    changelog = "https://github.com/humanoid-path-planner/hpp-pinocchio/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
