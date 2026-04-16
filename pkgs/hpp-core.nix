{
  lib,
  fetchFromGitHub,
  stdenv,

  # nativeBuildInputs
  cmake,
  doxygen,

  # propagatedBuildInputs
  hpp-constraints,
  jrl-cmakemodules,
  proxsuite,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-core";
  version = "7.0.0";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-core";
    # tag = "v${finalAttrs.version}";
    rev = "release/8.0.0";
    hash = "sha256-T+aUnyZ5rtXy+ZULARtMgwTvqMn0i6iJG8+r0aQkWso=";
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
    hpp-constraints
    proxsuite
  ];

  doCheck = true;

  meta = {
    description = "The core algorithms of the Humanoid Path Planner framework";
    homepage = "https://github.com/humanoid-path-planner/hpp-core";
    changelog = "https://github.com/humanoid-path-planner/hpp-core/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
