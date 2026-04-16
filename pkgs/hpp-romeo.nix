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
  version = "7.0.0";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-romeo";
    # tag = "v${finalAttrs.version}";
    rev = "release/8.0.0";
    hash = "sha256-QRe0NlIVPzyLwex3C1vnhukss6hoQ5WWs5ZusGRD1Wk=";
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
