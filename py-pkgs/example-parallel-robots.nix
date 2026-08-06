{
  lib,
  fetchFromGitHub,
  stdenv,
  python,
  toPythonModule,

  # nativeBuildInputs
  pythonImportsCheckHook,

  # buildInputs
  jrl-cmakemodules,

  # propagatedBuildInputs
  pinocchio,
  pyyaml,
  toolbox-parallel-robots,

  nix-update-script,
}:

toPythonModule (
  stdenv.mkDerivation (finalAttrs: {
    pname = "example-parallel-robots";
    version = "1.0.0";

    src = fetchFromGitHub {
      owner = "Gepetto";
      repo = "example-parallel-robots";
      tag = "v${finalAttrs.version}";
      hash = "sha256-AXkbA+j7w5n+zSgDLHCXkkYgV2utR259P1B4O/Th62I=";
    };

    nativeBuildInputs = jrl-cmakemodules.docsNativeBuildInputs ++ [
      pythonImportsCheckHook
    ];

    buildInputs = [
      jrl-cmakemodules
    ];

    propagatedBuildInputs = [
      pinocchio
      pyyaml
      toolbox-parallel-robots
    ];

    cmakeFlags = jrl-cmakemodules.docsNativeBuildInputs ++ [
      (lib.cmakeBool "BUILD_PYTHON_INTERFACE" true)
      (lib.cmakeBool "BUILD_TESTING" finalAttrs.doCheck)
      # Not sure why jrl-cmakemodule fail to set this here
      (lib.cmakeFeature "PYTHON_SITELIB" python.sitePackages)
    ];

    doCheck = false; # TODO BAD_COMMAND ?
    pythonImportsCheck = [ "example_parallel_robots" ];

    passthru.updateScript = nix-update-script { };

    meta = {
      description = "Set of parallel robot models for general use in benchmarks and examples";
      homepage = "https://github.com/Gepetto/example-parallel-robots";
      license = lib.licenses.bsd3;
      maintainers = with lib.maintainers; [ nim65s ];
      platforms = lib.platforms.unix;
    };
  })
)
