{
  lib,
  fetchFromGitHub,
  fetchpatch2,
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
  version = "8.0.0";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-gui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cYUaSlj7S9BZf7ZSqxApb2IldWMd4DxoJ9okPAQlnU4=";
  };

  # https://github.com/humanoid-path-planner/hpp-gui/pull/147
  patches = [
    (fetchpatch2 {
      url = "https://github.com/humanoid-path-planner/hpp-gui/pull/147.patch?full_index=1";
      hash = "sha256-m6D3TInfhfOoT/BzOqUkflUQV/r7tLbxsVfeuCvjtG0=";
    })
  ];

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
