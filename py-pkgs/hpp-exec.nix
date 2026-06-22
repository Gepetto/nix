{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  nix-update-script,
  toPythonModule,
  jrl-cmakemodules,
}:

toPythonModule (
  stdenv.mkDerivation (_finalAttrs: {
    pname = "hpp-exec";
    version = "0-unstable-2026-06-22";
    __structuredAttrs = true;
    strictDeps = true;

    src = fetchFromGitHub {
      owner = "humanoid-path-planner";
      repo = "hpp-exec";
      rev = "a106254cb3298a3989e482c92f2a829af718c118";
      hash = "sha256-jG/pW9Fe0BkqzXpJ8CWh/MzAHcM8KZKb/zLmjeoOCSE=";
    };

    nativeBuildInputs = [
      cmake
    ];

    buildInputs = [
      jrl-cmakemodules
    ];

    passthru.updateScript = nix-update-script { };

    meta = {
      description = "ROS2 execution utilities for HPP-generated trajectories";
      homepage = "https://github.com/humanoid-path-planner/hpp-exec";
      license = lib.licenses.bsd2;
      maintainers = with lib.maintainers; [ nim65s ];
      platforms = lib.platforms.all;
    };
  })
)
