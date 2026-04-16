{
  lib,
  fetchFromGitHub,
  stdenv,
  jrl-cmakemodules,

  pythonSupport ? false,
  python3Packages,

  # nativeBuildInputs
  cmake,
  doxygen,
  pkg-config,

  # propagatedBuildInputs
  hpp-corbaserver,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-romeo";
  version = "8.0.0";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-romeo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3v9BuUV1Ze8tlENQFH2appkWn/9oaFezIt8QxLRNN5g=";
  };

  outputs = [
    "out"
    "doc"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    doxygen
    pkg-config
  ]
  ++ lib.optional pythonSupport python3Packages.python;

  buildInputs = [ jrl-cmakemodules ];

  propagatedBuildInputs =
    lib.optional pythonSupport python3Packages.hpp-corbaserver
    ++ lib.optional (!pythonSupport) hpp-corbaserver;

  cmakeFlags = [
    (lib.cmakeBool "BUILD_PYTHON_INTERFACE" pythonSupport)
  ];

  doCheck = true;

  meta = {
    description = "Python and ros launch files for Romeo robot in hpp";
    homepage = "https://github.com/humanoid-path-planner/hpp_romeo";
    changelog = "https://github.com/humanoid-path-planner/hpp_romeo/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
