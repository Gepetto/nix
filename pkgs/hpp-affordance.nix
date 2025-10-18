{
  lib,
  fetchFromGitHub,
  stdenv,

  # nativeBuildInputs
  cmake,
  doxygen,
  pkg-config,

  # propagatedBuildInputs
  coal,
  jrl-cmakemodules,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-affordance";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-affordance";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UuhoYfSOY6QoENjuhA8uTARiDwPF2BoJ3gHvPOP5Qng=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-warn \
      "cmake_minimum_required(VERSION 3.10)" \
      "cmake_minimum_required(VERSION 3.22)"
  '';

  outputs = [
    "out"
    "doc"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    doxygen
    pkg-config
  ];
  propagatedBuildInputs = [
    coal
    jrl-cmakemodules
  ];

  meta = {
    description = "Implements affordance extraction for multi-contact planning";
    homepage = "https://github.com/humanoid-path-planner/hpp-affordance";
    changelog = "https://github.com/humanoid-path-planner/hpp-affordance/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
