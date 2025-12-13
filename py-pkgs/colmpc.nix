{
  lib,

  pkgs,

  toPythonModule,
  pythonImportsCheckHook,

  buildStandalone ? true,

  crocoddyl,
  mim-solvers,
  numdifftools,
}:
toPythonModule (
  pkgs.colmpc.overrideAttrs (super: {
    pname = "py-${super.pname}";

    cmakeFlags = (super.cmakeFlags or [ ]) ++ [
      (lib.cmakeBool "BUILD_PYTHON_INTERFACE" true)
      (lib.cmakeBool "BUILD_STANDALONE_PYTHON_INTERFACE" buildStandalone)
    ];

    propagatedBuildInputs =
      (super.propagatedBuildInputs or [ ])
      ++ [
        crocoddyl
      ]
      ++ lib.optional buildStandalone pkgs.colmpc;

    nativeCheckInputs = (super.nativeCheckInputs or [ ]) ++ [
      pythonImportsCheckHook
    ];

    checkInputs = [
      mim-solvers
      numdifftools
    ];

    pythonImportsCheck = [ "colmpc" ];
  })
)
