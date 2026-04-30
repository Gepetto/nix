{
  lib,
  toPythonModule,
  pkgs,

  boost,
  eigenpy,
  python,
  pythonImportsCheckHook,

  buildStandalone ? true,
}:
toPythonModule (
  pkgs.flex-joints.overrideAttrs (super: {
    pname = "py-${super.pname}";
    cmakeFlags = super.cmakeFlags ++ [
      (lib.cmakeBool "BUILD_PYTHON_INTERFACE" true)
      (lib.cmakeBool "BUILD_STANDALONE_PYTHON_INTERFACE" buildStandalone)
    ];
    nativeBuildInputs = [
      python
    ]
    ++ super.nativeBuildInputs;

    propagatedBuildInputs = [
      boost
      eigenpy
      pythonImportsCheckHook
    ]
    ++ super.propagatedBuildInputs
    ++ lib.optional buildStandalone pkgs.flex-joints;

    pythonImportsCheck = [ "flex_joints" ];
  })
)
