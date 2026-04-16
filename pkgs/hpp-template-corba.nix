{
  lib,
  fetchFromGitHub,
  stdenv,
  jrl-cmakemodules,

  cmake,
  doxygen,
  omniorb,
  pkg-config,
  hpp-util,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-template-corba";
  version = "7.0.0";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-template-corba";
    # tag = "v${finalAttrs.version}";
    rev = "release/8.0.0";
    hash = "sha256-4wDMAOJ9h+HDtgz1euDi1ktl9mn1Gg/zhDwYSKpZM+c=";
  };

  outputs = [
    "out"
    "doc"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    doxygen
    omniorb
    pkg-config
  ];

  buildInputs = [ jrl-cmakemodules ];

  propagatedBuildInputs = [
    hpp-util
    omniorb
  ];

  doCheck = true;

  meta = {
    description = "This package is intended to ease construction of CORBA servers by templating actions that are common to all servers";
    homepage = "https://github.com/humanoid-path-planner/hpp-template-corba";
    changelog = "https://github.com/humanoid-path-planner/hpp-template-corba/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
