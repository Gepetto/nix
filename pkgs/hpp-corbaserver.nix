{
  lib,
  fetchFromGitHub,
  runCommand,
  stdenv,

  # nativeBuildInputs
  omniorb,
  python3Packages,

  # propagatedBuildInputs
  hpp-core,
  hpp-template-corba,
  jrl-cmakemodules,
  makeWrapper,

  # nativeCheckInputs
  psmisc,

  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-corbaserver";
  version = "9.0.0";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-corbaserver";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+BoNcHXT+WrLlvK6WpeSfRv7l7gTZG5dStt0/MC1yIs=";
  };

  prePatch = ''
    patchShebangs --build tests/hppcorbaserver.sh
  '';

  outputs = [
    "out"
    "doc"
  ];

  nativeBuildInputs = jrl-cmakemodules.docsNativeBuildInputs ++ [
    omniorb
    python3Packages.python
    python3Packages.pythonImportsCheckHook
  ];

  buildInputs = [ jrl-cmakemodules ];

  propagatedBuildInputs = [
    hpp-core
    hpp-template-corba
    python3Packages.omniorbpy
    python3Packages.numpy
  ];

  propagatedNativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    psmisc
  ];

  enableParallelBuilding = false;

  cmakeFlags = jrl-cmakemodules.docsCmakeFlags ++ [
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.doCheck)
  ];

  # psmisc is only available on linux
  doCheck = stdenv.hostPlatform.isLinux;

  pythonImportsCheck = [ "hpp.corbaserver" ];

  passthru.withPlugins =
    plugins:
    runCommand "hppcorbaserver" { nativeBuildInputs = [ makeWrapper ]; } ''
      makeWrapper ${lib.getExe finalAttrs.finalPackage} $out/bin/hppcorbaserver \
        --set HPP_PLUGIN_DIRS ${lib.makeLibraryPath plugins}
    '';

  strictDeps = true;
  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Corba server for Humanoid Path Planner applications";
    homepage = "https://github.com/humanoid-path-planner/hpp-corbaserver";
    changelog = "https://github.com/humanoid-path-planner/hpp-corbaserver/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
    mainProgram = "hppcorbaserver";
    platforms = lib.platforms.unix;
  };
})
