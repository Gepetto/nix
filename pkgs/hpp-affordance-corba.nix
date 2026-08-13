{
  lib,
  fetchFromGitHub,
  stdenv,

  # nativeBuildInputs
  python3Packages,

  # propagatedBuildInputs
  hpp-affordance,
  jrl-cmakemodules,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-affordance-corba";
  version = "9.0.0";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-affordance-corba";
    tag = "v${finalAttrs.version}";
    hash = "sha256-d/50P/Mt2RTDuXaE7aiYbSfpjFnI8xEf8KuB7a9zt/o=";
  };

  outputs = [
    "out"
    "doc"
  ];

  nativeBuildInputs = jrl-cmakemodules.docsNativeBuildInputs ++ [
    python3Packages.omniorb
    python3Packages.python
  ];

  buildInputs = [
    jrl-cmakemodules
    python3Packages.boost
  ];

  propagatedBuildInputs = [
    hpp-affordance
    python3Packages.hpp-corbaserver
    python3Packages.omniorbpy
  ];

  enableParallelBuilding = false;

  cmakeFlags = jrl-cmakemodules.docsCmakeFlags ++ [
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.doCheck)
  ];

  doCheck = true;

  strictDeps = true;
  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "corbaserver to provide affordance utilities in python";
    homepage = "https://github.com/humanoid-path-planner/hpp-affordance-corba";
    changelog = "https://github.com/humanoid-path-planner/hpp-affordance-corba/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
