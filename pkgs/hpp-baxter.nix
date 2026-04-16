{
  lib,
  fetchFromGitHub,
  stdenv,

  pythonSupport ? false,
  python3Packages,

  # nativeBuildInputs
  cmake,
  doxygen,

  # propagatedBuildInputs
  example-robot-data,
  jrl-cmakemodules,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-baxter";
  version = "8.0.0";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-baxter";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EBJTv50A/JzTcTFyfJoKrNf2zOR+BmV4muJmJxpW2KE=";
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

  propagatedBuildInputs = [
    example-robot-data
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_PYTHON_INTERFACE" pythonSupport)
  ];

  doCheck = true;

  meta = {
    description = "Wrappers for Baxter robot in HPP";
    homepage = "https://github.com/humanoid-path-planner/hpp-baxter";
    changelog = "https://github.com/humanoid-path-planner/hpp-baxter/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
