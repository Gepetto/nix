{
  lib,
  fetchFromGitHub,
  stdenv,

  # nativeBuildInputs
  cmake,
  doxygen,
  pkg-config,
  python3Packages,

  # propagatedBuildInputs
  hpp-affordance,
  jrl-cmakemodules,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-affordance-corba";
  version = "8.0.0";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-affordance-corba";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dZttq+PNP031yMG4wxVJJ5WFp46EmIW0shmlh7LrFvg=";
  };

  outputs = [
    "out"
    "doc"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    doxygen
    pkg-config
    python3Packages.omniorb
    python3Packages.python
  ];

  buildInputs = [
    jrl-cmakemodules
    python3Packages.boost
  ];

  propagatedBuildInputs = [
    hpp-affordance
    python3Packages.hpp-corbaserver
    python3Packages.omniorbpy
  ];

  enableParallelBuilding = false;

  doCheck = true;

  meta = {
    description = "corbaserver to provide affordance utilities in python";
    homepage = "https://github.com/humanoid-path-planner/hpp-affordance-corba";
    changelog = "https://github.com/humanoid-path-planner/hpp-affordance-corba/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
