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
  pname = "hpp-tutorial";
  version = "7.0.0";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-tutorial";
    # tag = "v${finalAttrs.version}";
    rev = "release/8.0.0";
    hash = "sha256-VioTkvozQISpwdvjbX3FgK1vpL/OD7dxWC73Gf628EE=";
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
    python3Packages.hpp-gepetto-viewer
    python3Packages.hpp-manipulation-corba
  ];

  doCheck = true;

  meta = {
    description = "Tutorial for humanoid path planner platform";
    homepage = "https://github.com/humanoid-path-planner/hpp_tutorial";
    changelog = "https://github.com/humanoid-path-planner/hpp_tutorial/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
