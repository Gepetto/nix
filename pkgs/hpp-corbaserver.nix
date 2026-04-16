{
  lib,
  fetchFromGitHub,
  runCommand,
  stdenv,

  # nativeBuildInputs
  cmake,
  doxygen,
  omniorb,
  pkg-config,
  python3Packages,

  # propagatedBuildInputs
  hpp-core,
  hpp-template-corba,
  jrl-cmakemodules,
  makeWrapper,

  # checkInputs
  psmisc,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-corbaserver";
  version = "8.0.0";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-corbaserver";
    tag = "v${finalAttrs.version}";
    hash = "sha256-e0yivzXnY1rovtAYv0jfOCqgYWYhUEh0aOQMeo+24Lw=";
  };

  prePatch = ''
    substituteInPlace tests/hppcorbaserver.sh \
      --replace-fail /bin/bash ${stdenv.shell}
  '';

  outputs = [
    "out"
    "doc"
  ];

  nativeBuildInputs = [
    cmake
    doxygen
    omniorb
    pkg-config
    python3Packages.pythonImportsCheckHook
  ];

  buildInputs = [ jrl-cmakemodules ];

  propagatedBuildInputs = [
    hpp-core
    hpp-template-corba
    python3Packages.omniorbpy
    python3Packages.numpy
  ];

  checkInputs = [
    psmisc
  ];

  enableParallelBuilding = false;

  # psmisc is only available on linux
  doCheck = stdenv.isLinux;

  pythonImportsCheck = [ "hpp.corbaserver" ];

  passthru.withPlugins =
    plugins:
    runCommand "hppcorbaserver" { nativeBuildInputs = [ makeWrapper ]; } ''
      makeWrapper ${lib.getExe finalAttrs.finalPackage} $out/bin/hppcorbaserver \
        --set HPP_PLUGIN_DIRS ${lib.makeLibraryPath plugins}
    '';

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
