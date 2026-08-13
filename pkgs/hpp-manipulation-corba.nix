{
  lib,
  fetchFromGitHub,
  stdenv,
  jrl-cmakemodules,

  # nativeBuildInputs
  omniorb,
  python3Packages,

  # propagatedBuildInputs
  hpp-manipulation-urdf,

  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-manipulation-corba";
  version = "9.0.0";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-manipulation-corba";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3mmBZqfEcUuBVVNfRGvCg0ZSbPgbIjT/yXwjzczPI5U=";
  };

  outputs = [
    "out"
    "doc"
  ];

  nativeBuildInputs = jrl-cmakemodules.docsNativeBuildInputs ++ [
    omniorb
    python3Packages.python
  ];

  buildInputs = [
    jrl-cmakemodules
  ];

  propagatedBuildInputs = [
    hpp-manipulation-urdf
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
    description = "Corba server for manipulation planning";
    homepage = "https://github.com/humanoid-path-planner/hpp-manipulation-corba";
    changelog = "https://github.com/humanoid-path-planner/hpp-manipulation-corba/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
