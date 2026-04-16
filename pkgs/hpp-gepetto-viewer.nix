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
  pname = "hpp-gepetto-viewer";
  version = "7.0.0";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-gepetto-viewer";
    # tag = "v${finalAttrs.version}";
    rev = "release/8.0.0";
    hash = "sha256-WSqR2pF1lvLaZ0Qcdcd0HL2vJw2gZI9oXXuM1VLdZt8=";
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
    python3Packages.hpp-corbaserver
    python3Packages.hpp-python
    python3Packages.pycollada
    python3Packages.trimesh
    python3Packages.viser
  ];

  doCheck = true;

  meta = {
    description = "Display of hpp robots and obstacles in gepetto-viewer";
    homepage = "https://github.com/humanoid-path-planner/hpp-gepetto-viewer";
    changelog = "https://github.com/humanoid-path-planner/hpp-gepetto-viewer/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
