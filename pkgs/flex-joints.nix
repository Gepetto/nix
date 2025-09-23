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

  # checkInputs
  gtest,

  pythonSupport ? false,
}:

stdenv.mkDerivation (_finalAttrs: {
  pname = "flex-joints";
  version = "1.1.0-unstable-2025-09-23";

  src = fetchFromGitHub {
    owner = "Gepetto";
    repo = "flex-joints";
    #tag = "v${finalAttrs.version}";
    rev = "8bc4df14a05113e52d31c4f26363e5ccfed9bcce";
    hash = "sha256-pA30qMbseM1oGUk0Z2YUF+bSobNukIUrLWcno0OfoBo=";
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

  checkInputs = [ gtest ];

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
