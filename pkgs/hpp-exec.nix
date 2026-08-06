{
  lib,
  fetchFromGitHub,
  stdenv,

  # nativeBuildInputs
  python3Packages,

  # buildInputs
  jrl-cmakemodules,

  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-exec";
  version = "9.0.2";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-exec";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zLNZaCO5t1rIIwRRNs9yrjpHfrN+9wiPGld3ub4Z9Co=";
  };

  nativeBuildInputs = jrl-cmakemodules.docsNativeBuildInputs ++ [
    python3Packages.python
  ];

  buildInputs = [
    jrl-cmakemodules
  ];

  cmakeFlags = jrl-cmakemodules.docsCmakeFlags ++ [
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.doCheck)
  ];

  doCheck = true;

  strictDeps = true;
  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "ROS2 execution utilities for HPP-generated trajectories";
    homepage = "https://github.com/humanoid-path-planner/hpp-exec";
    changelog = "https://github.com/humanoid-path-planner/hpp-exec/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.all;
  };
})
