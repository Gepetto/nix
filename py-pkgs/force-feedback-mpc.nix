{
  lib,

  pkgs,

  toPythonModule,
  pythonImportsCheckHook,

  standalone ? true,

  # propagatedBuildInputs
  boost,
  eigenpy,
  pinocchio,
  crocoddyl,
}:
toPythonModule (
  pkgs.force-feedback-mpc.overrideAttrs (super: {
    pname = "py-${super.pname}";

    cmakeFlags = (super.cmakeFlags or [ ]) ++ [
      (lib.cmakeBool "BUILD_PYTHON_INTERFACE" true)
      (lib.cmakeBool "BUILD_STANDALONE_PYTHON_INTERFACE" standalone)
      (lib.cmakeBool "INSTALL_PYTHON_INTERFACE_ONLY" standalone)
    ];

    propagatedBuildInputs = [
      boost
      eigenpy
      pinocchio
      crocoddyl
    ]
    ++ lib.optional standalone pkgs.force-feedback-mpc;

    checkInputs = [ ];

    nativeCheckInputs = (super.nativeCheckInputs or [ ]) ++ [
      pythonImportsCheckHook
    ];

    pythonImportsCheck = [ "force_feedback_mpc" ];
  })
)
