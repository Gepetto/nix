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
}:

stdenv.mkDerivation (_finalAttrs: {
  pname = "hpp-toppra";
  version = "0-unstable-2026-03-19";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-toppra";
    rev = "cdf624daede95f17d7f1cdec58435b712b4e3d21";
    hash = "sha256-f+bc0pLNiAcOObarHuiGZHFs0jbmbS82od1f1eKS6f4=";
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

  meta = {
    description = "Integration of TOPPRA algorithm in HPP";
    homepage = "https://github.com/humanoid-path-planner/hpp-toppra";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.all;
  };
})
