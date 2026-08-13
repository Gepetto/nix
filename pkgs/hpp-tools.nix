{
  lib,
  fetchFromGitHub,
  stdenv,

  jrl-cmakemodules,

  python3Packages,

  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-tools";
  version = "9.0.0";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-tools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tTZszs4iqoGvTO3+hZ8ivBHV+box5VQyZ7Zrr3De9EY=";
  };

  outputs = [
    "out"
    "doc"
  ];

  nativeBuildInputs = jrl-cmakemodules.docsNativeBuildInputs ++ [
    python3Packages.python
  ];

  buildInputs = [ jrl-cmakemodules ];

  propagatedBuildInputs = [
    python3Packages.numpy
  ];

  cmakeFlags = jrl-cmakemodules.docsCmakeFlags ++ [
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.doCheck)
  ];

  doCheck = true;

  strictDeps = true;
  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Various tools for hpp";
    homepage = "https://github.com/humanoid-path-planner/hpp-tools";
    changelog = "https://github.com/humanoid-path-planner/hpp-corbaserver/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
