{
  lib,
  fetchFromGitHub,
  stdenv,

  # nativeBuildInputs
  libsForQt5,
  python3Packages,

  # buildInputs
  jrl-cmakemodules,

  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-gepetto-viewer";
  version = "9.0.2";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-gepetto-viewer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ml7ehrhUYtC7yvAF4+a0+dgpSXIZW86SnshovJ1XvRU=";
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
    python3Packages.boost
    python3Packages.gepetto-viewer-corba
    python3Packages.hpp-corbaserver
    python3Packages.hpp-python
    python3Packages.pycollada
    python3Packages.trimesh
    python3Packages.viser
  ];

  cmakeFlags = jrl-cmakemodules.docsCmakeFlags ++ [
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.doCheck)
  ];

  doCheck = true;

  strictDeps = true;
  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Display of hpp robots and obstacles in gepetto-viewer";
    homepage = "https://github.com/humanoid-path-planner/hpp-gepetto-viewer";
    changelog = "https://github.com/humanoid-path-planner/hpp-gepetto-viewer/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
