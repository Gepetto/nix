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
  qpsolvers,
  scipy,

  nix-update-script,
}:

toPythonModule (
  stdenv.mkDerivation (finalAttrs: {
    pname = "toolbox-parallel-robots";
    version = "1.2.0";

    src = fetchFromGitHub {
      owner = "gepetto";
      repo = "toolbox-parallel-robots";
      tag = "v${finalAttrs.version}";
      hash = "sha256-tFMKVhBhA3zXEt4Yb8btI0LYc84SndpgfMsJSUlLL48=";
    };

    nativeBuildInputs = jrl-cmakemodules.docsNativeBuildInputs ++ [
      pythonImportsCheckHook
    ];

    buildInputs = [
      jrl-cmakemodules
    ];

    propagatedBuildInputs = [
      pinocchio
      qpsolvers
      scipy
    ];

    cmakeFlags = jrl-cmakemodules.docsNativeBuildInputs ++ [
      (lib.cmakeBool "BUILD_TESTING" finalAttrs.doCheck)
      # Not sure why jrl-cmakemodules fail to set this here
      (lib.cmakeFeature "PYTHON_SITELIB" python.sitePackages)
    ];

    doCheck = true;
    pythonImportsCheck = [ "toolbox_parallel_robots" ];

    passthru.updateScript = nix-update-script { };

    meta = {
      description = "Set of tools to work with robots with bilateral constraints";
      homepage = "https://github.com/gepetto/toolbox-parallel-robots";
      license = lib.licenses.bsd3;
      maintainers = with lib.maintainers; [ nim65s ];
      platforms = lib.platforms.unix;
    };
  })
)
