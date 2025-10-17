{
  lib,

  fetchFromGitHub,
  fetchpatch,
  stdenv,

  # Native build inputs
  cmake,

  # Propagated build inputs
  boost,
  jrl-cmakemodules,
  ndcurves,
  pinocchio,

  python3Packages,
  pythonSupport ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "multicontact-api";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "loco-3d";
    repo = "multicontact-api";
    tag = "v${finalAttrs.version}";
    hash = "sha256-c46nGfcqzMjDcmtiYptTZxXmEEc99KZuHbSsRTWrhCo=";
  };

  patches = [
    # fix darwin lib name, ref PR 78
    (fetchpatch {
      url = "https://github.com/loco-3d/multicontact-api/pull/78/commits/abf30c228d3e335f3a4f4e753db351a70457a508.patch";
      hash = "sha256-f//w6wr6PncrvzbtHdb3qWGGLT77NPDY3f8TYFvRins=";
    })
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail \
      "cmake_minimum_required(VERSION 3.10)" \
      "cmake_minimum_required(VERSION 3.22)"
  '';
  nativeBuildInputs = [
    cmake
  ];

  propagatedBuildInputs = [
    boost
    jrl-cmakemodules
  ]
  ++ lib.optionals (!pythonSupport) [
    ndcurves
    pinocchio
  ]
  ++ lib.optionals pythonSupport [
    python3Packages.boost
    python3Packages.eigenpy
    python3Packages.example-robot-data
    python3Packages.ndcurves
    python3Packages.pinocchio
    python3Packages.pythonImportsCheckHook
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_PYTHON_INTERFACE" pythonSupport)
  ];

  doCheck = true;
  pythonImportsCheck = [ "multicontact_api" ];

  meta = {
    description = "define, store and use ContactSequence objects";
    homepage = "https://github.com/loco-3d/multicontact-api";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.unix;
  };
})
