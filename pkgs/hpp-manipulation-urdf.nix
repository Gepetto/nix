{
  lib,
  fetchFromGitHub,
  stdenv,
  jrl-cmakemodules,

  # nativeBuildInputs
  cmake,
  doxygen,

  # propagatedBuildInputs
  hpp-manipulation,

  # checkInputs
  example-robot-data,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-manipulation-urdf";
  version = "7.0.0";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-manipulation-urdf";
    # tag = "v${finalAttrs.version}";
    rev = "release/8.0.0";
    hash = "sha256-mZAYO30rrUmH/yYKAqbU+CyGxOQILBEmb5K79JDpCxE=";
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

  propagatedBuildInputs = [ hpp-manipulation ];

  checkInputs = [ example-robot-data ];

  doCheck = true;

  meta = {
    description = "Implementation of a parser for hpp-manipulation";
    homepage = "https://github.com/humanoid-path-planner/hpp-manipulation-urdf";
    changelog = "https://github.com/humanoid-path-planner/hpp-manipulation-urdf/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
