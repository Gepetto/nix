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
    rev = "141d2bfe9c70e77db23e3e4b63209b78052f2b07";
    hash = lib.fakeHash;
  };

  nativeBuildInputs = [
    cmake
  ];

  propagatedBuildInputs =
    [
      eigen
      jrl-cmakemodules
      boost
    ]
    ++ lib.optionals pythonSupport [
      python3Packages.boost
      python3Packages.eigenpy
      python3Packages.pythonImportsCheckHook
    ];

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