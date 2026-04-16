{
  lib,
  fetchFromGitHub,
  stdenv,

  # nativeBuildInputs
  cmake,
  doxygen,

  # propagatedBuildInputs
  hpp-pinocchio,
  hpp-statistics,
  jrl-cmakemodules,
  qpoases,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-constraints";
  version = "7.0.0";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-constraints";
    # tag = "v${finalAttrs.version}";
    rev = "release/8.0.0";
    hash = "sha256-V08BJ50vslYXcs6Zy2ZvSJbij7Wne511ofFMglR2VSY=";
  };

  outputs = [
    "out"
    "doc"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    doxygen
  ];
  buildInputs = [ jrl-cmakemodules ];

  propagatedBuildInputs = [
    hpp-pinocchio
    hpp-statistics
    qpoases
  ];

  doCheck = true;

  cmakeFlags = lib.optional stdenv.hostPlatform.isDarwin "-DCMAKE_CTEST_ARGUMENTS=--exclude-regex;'test-jacobians|solver-by-substitution'";

  meta = {
    description = "Definition of basic geometric constraints for motion planning";
    homepage = "https://github.com/humanoid-path-planner/hpp-constraints";
    changelog = "https://github.com/humanoid-path-planner/hpp-constraints/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
