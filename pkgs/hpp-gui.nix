{
  lib,
  fetchFromGitHub,
  stdenv,

  cmake,
  doxygen,
  jrl-cmakemodules,
  libsForQt5,
  pkg-config,
  python3Packages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-gui";
  version = "7.0.0";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-gui";
    # tag = "v${finalAttrs.version}";
    rev = "release/8.0.0";
    hash = "sha256-5mWTC4OqWR13pMsPtafoF1ZbffWH5Y9DZucJ4j+tmuE=";
  };

  outputs = [
    "out"
    "doc"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    doxygen
    libsForQt5.wrapQtAppsHook
    pkg-config
    python3Packages.python
  ];

  buildInputs = [
    jrl-cmakemodules
    libsForQt5.qtbase
  ];

  propagatedBuildInputs = [
    python3Packages.gepetto-viewer-corba
    python3Packages.hpp-manipulation-corba
  ];

  doCheck = true;

  meta = {
    description = "Qt based GUI for HPP project";
    homepage = "https://github.com/humanoid-path-planner/hpp-gui";
    changelog = "https://github.com/humanoid-path-planner/hpp-gui/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
