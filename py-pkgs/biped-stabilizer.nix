{
  lib,

  toPythonModule,
  pythonImportsCheckHook,

  pkgs,

  boost,
  eigenpy,
  example-robot-data,
  pinocchio,
  python,

  buildStandalone ? true,
}:
toPythonModule (
  pkgs.biped-stabilizer.overrideAttrs (super: {
    pname = "py-${super.pname}";

    cmakeFlags = super.cmakeFlags ++ [
      (lib.cmakeBool "BUILD_PYTHON_INTERFACE" true)
      (lib.cmakeBool "BUILD_STANDALONE_PYTHON_INTERFACE" buildStandalone)
    ];

    nativeBuildInputs = super.nativeBuildInputs ++ [
      python
    ];

    propagatedBuildInputs =
      (super.propagatedBuildInputs or [ ])
      ++ [
        boost
        eigenpy
        example-robot-data
        pinocchio
      ]
      ++ lib.optional buildStandalone pkgs.biped-stabilizer;

    nativeCheckInputs = (super.nativeCheckInputs or [ ]) ++ [
      pythonImportsCheckHook
    ];

    pythonImportsCheck = [
      "biped_stabilizer"
    ];
  })
)
