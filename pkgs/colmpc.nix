{
  lib,
  stdenv,

  fetchFromGitHub,

  pythonSupport ? false,
  python3Packages,

  # nativeBuildInputs
  cmake,
  pkg-config,

  # buildInputs
  llvmPackages,

  # propagatedBuildInputs
  crocoddyl,
  ipopt,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "colmpc";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "agimus-project";
    repo = "colmpc";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qvMD3uKRgb0+92DISEX9gfTX708+nmq8tlWjOtfE2yg=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ]
  ++ lib.optional pythonSupport python3Packages.pythonImportsCheckHook;

  buildInputs = lib.optional stdenv.cc.isClang llvmPackages.openmp;

  propagatedBuildInputs = [
    ipopt
  ]
  ++ lib.optional pythonSupport python3Packages.crocoddyl
  ++ lib.optional (!pythonSupport) crocoddyl;

  checkInputs = lib.optionals pythonSupport [
    python3Packages.mim-solvers
    python3Packages.numdifftools
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_PYTHON_INTERFACE" pythonSupport)
  ];

  doCheck = true;
  pythonImportsCheck = [ "colmpc" ];

  meta = {
    description = "Collision avoidance for MPC";
    homepage = "https://github.com/agimus-project/colmpc";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.unix;
  };
})
