{
  lib,

  stdenv,
  fetchFromGitHub,

  # nativeBuildInputs
  cmake,

  # propagatedBuildInputs
  boost,
  eigen,
  jrl-cmakemodules,
  python3Packages,

  pythonSupport ? false,
}:

stdenv.mkDerivation (_finalAttrs: {
  pname = "flex-joints";
  version = "1.1.0-unstable-2025-09-23";

  src = fetchFromGitHub {
    owner = "Gepetto";
    repo = "flex-joints";
    #tag = "v${finalAttrs.version}";
    rev = "6bf5f0119bd0a4cb9449e1a40106c36d819eb6ff";
    hash = "sha256-O4eUjyP/WuqGzRhuYhcUkbEG4NPrIlE+RO9YAt13Hl4=";
  };

  nativeBuildInputs = [
    cmake
  ];

  propagatedBuildInputs =
    [
      eigen
      jrl-cmakemodules
    ]
    ++ lib.optionals pythonSupport [
      python3Packages.boost
      python3Packages.eigenpy
      python3Packages.pythonImportsCheckHook
    ];

    checkInputs = [ pkgs.gtest ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_PYTHON_INTERFACE" pythonSupport)
  ];

  doCheck = true;
  pythonImportsCheck = [ "flex_joints" ];

  meta = {
    description = "Adaptation for rigid control on flexible devices ";
    homepage = "https://github.com/Gepetto/flex-joints";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.unix;
  };
})