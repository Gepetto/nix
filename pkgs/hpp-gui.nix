{
  lib,
  fetchFromGitHub,
  stdenv,

  jrl-cmakemodules,
  libsForQt5,
  python3Packages,

  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-gui";
  version = "9.0.0";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-gui";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kfMUjLdk+8ZX4wTsbsKmWc7Ot+L5Bn/OkTp1QVUoB7c=";
  };

  outputs = [
    "out"
    "doc"
  ];

  nativeBuildInputs = jrl-cmakemodules.docsNativeBuildInputs ++ [
    libsForQt5.wrapQtAppsHook
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

  cmakeFlags = jrl-cmakemodules.docsCmakeFlags ++ [
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.doCheck)
  ];

  doCheck = true;

  strictDeps = true;
  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Qt based GUI for HPP project";
    homepage = "https://github.com/humanoid-path-planner/hpp-gui";
    changelog = "https://github.com/humanoid-path-planner/hpp-gui/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
