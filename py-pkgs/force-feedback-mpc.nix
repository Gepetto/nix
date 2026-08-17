{
  lib,

  pkgs,

  toPythonModule,
  pythonImportsCheckHook,

  buildStandalone ? true,

  # propagatedBuildInputs
  boost,
  eigenpy,
  pinocchio,
  python,
  crocoddyl,
}:
toPythonModule (
  pkgs.force-feedback-mpc.overrideAttrs (super: {
    pname = "py-${super.pname}";

    cmakeFlags = (super.cmakeFlags or [ ]) ++ [
      (lib.cmakeBool "BUILD_PYTHON_INTERFACE" true)
      (lib.cmakeBool "BUILD_STANDALONE_PYTHON_INTERFACE" buildStandalone)
      (lib.cmakeBool "INSTALL_PYTHON_INTERFACE_ONLY" buildStandalone)
    ];

    nativeBuildInputs = super.nativeBuildInputs ++ [
      python
    ];

    propagatedBuildInputs = [
      boost
      eigenpy
      pinocchio
      crocoddyl
    ]
    ++ lib.optional buildStandalone pkgs.force-feedback-mpc;

    checkInputs = [ ];

    nativeCheckInputs = (super.nativeCheckInputs or [ ]) ++ [
      pythonImportsCheckHook
    ];

    pythonImportsCheck = [ "force_feedback_mpc" ];
  })
)
