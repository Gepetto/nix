{
  lib,

  pkgs,

  toPythonModule,
  pythonImportsCheckHook,

  standalone ? true,

  boost,
  eigenpy,
  example-robot-data,
  ndcurves,
  pinocchio,
}:
toPythonModule (
  pkgs.multicontact-api.overrideAttrs (super: {
    pname = "py-${super.pname}";

    cmakeFlags = (super.cmakeFlags or [ ]) ++ [
      (lib.cmakeBool "BUILD_PYTHON_INTERFACE" true)
      (lib.cmakeBool "BUILD_STANDALONE_PYTHON_INTERFACE" standalone)
    ];

    propagatedBuildInputs =
      (super.propagatedBuildInputs or [ ])
      ++ [
        boost
        eigenpy
        example-robot-data
        ndcurves
        pinocchio
      ]
      ++ lib.optional standalone pkgs.multicontact-api;

    nativeCheckInputs = (super.nativeCheckInputs or [ ]) ++ [
      pythonImportsCheckHook
    ];

    pythonImportsCheck = [ "multicontact_api" ];
  })
)
