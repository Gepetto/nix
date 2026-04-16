{
  lib,
  stdenv,
  fetchFromGitHub,

  # nativeBuildInputs
  cmake,
  pkg-config,
  hpp-core,
  hpp-manipulation,

  # buildInputs
  jrl-cmakemodules,
  python3Packages,
  toppra,

  # checkInputs
  catch2_3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-toppra";
  version = "0-unstable-2026-03-19";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-toppra";
    rev = "release/8.0.0";
    hash = "sha256-WFoD6MzeCqTVNxSv45zOJqF1L0skfYRivyeFN9962pw=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    jrl-cmakemodules
    hpp-core
    hpp-manipulation
    python3Packages.boost
    python3Packages.eigenpy
    python3Packages.numpy
    python3Packages.hpp-python
    toppra
  ];

  checkInputs = [
    catch2_3
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.doCheck)
  ];

  doCheck = true;

  meta = {
    description = "Integration of TOPPRA algorithm in HPP";
    homepage = "https://github.com/humanoid-path-planner/hpp-toppra";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.all;
  };
})
