{
  lib,
  fetchFromGitHub,
  stdenv,

  python3Packages,
  pythonSupport ? false,

  # nativeBuildInputs
  cmake,
  doxygen,

  # propagatedBuildInputs
  boost,
  example-robot-data,
  jrl-cmakemodules,
  pinocchio,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-environments";
  version = "7.0.0";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-environments";
    # tag = "v${finalAttrs.version}";
    rev = "release/8.0.0";
    hash = "sha256-HF7Bwaq9T2TcCAU/atM8bLRxsYw6XB75d9NDtNHNYHk=";
  };

  outputs = [
    "out"
    "doc"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    doxygen
  ]
  ++ lib.optional pythonSupport python3Packages.python;

  buildInputs = [ jrl-cmakemodules ];

  propagatedBuildInputs =
    lib.optionals pythonSupport [
      python3Packages.boost
      python3Packages.eigenpy
      python3Packages.pinocchio
      python3Packages.example-robot-data
    ]
    ++ lib.optionals (!pythonSupport) [
      boost
      pinocchio
      example-robot-data
    ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_PYTHON_INTERFACE" pythonSupport)
  ];

  doCheck = true;

  meta = {
    description = "Environments and robot descriptions for HPP";
    homepage = "https://github.com/humanoid-path-planner/hpp-environments";
    changelog = "https://github.com/humanoid-path-planner/hpp-environments/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
