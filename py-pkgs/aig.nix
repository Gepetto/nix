{
  lib,

  pkgs,

  toPythonModule,
  pythonImportsCheckHook,

  buildStandalone ? true,

  boost,
  eigenpy,
  example-robot-data,
  pinocchio,
}:
toPythonModule (
  pkgs.aig.overrideAttrs (super: {
    pname = "py-${super.pname}";

    cmakeFlags = (super.cmakeFlags or [ ]) ++ [
      (lib.cmakeBool "BUILD_PYTHON_INTERFACE" true)
      (lib.cmakeBool "BUILD_STANDALONE_PYTHON_INTERFACE" buildStandalone)
    ];

    propagatedBuildInputs =
      (super.propagatedBuildInputs or [ ])
      ++ [
        boost
        eigenpy
        example-robot-data
        pinocchio
      ]
      ++ lib.optional buildStandalone pkgs.aig;

    nativeCheckInputs = (super.nativeCheckInputs or [ ]) ++ [
      pythonImportsCheckHook
    ];

    pythonImportsCheck = [ "aig" ];
  })
)
