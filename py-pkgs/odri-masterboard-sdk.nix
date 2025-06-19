{
  src-odri-masterboard-sdk,

  lib,
  stdenv,
  jrl-cmakemodules,
  cmake,
  python,
  numpy,
  boost,
  catch2_3,
}:

stdenv.mkDerivation {
  pname = "odri_master_board_sdk";
  # replaced by version from package.xml in the repository's flake
  version = "1.0.7";

  src = src-odri-masterboard-sdk;

  # TODO sourceRoot = "${src.name}/sdk/master_board_sdk"; when we'll switch to fetchFromGitHub
  preConfigure = ''
    cd sdk/master_board_sdk
  '';

  doCheck = true;

  cmakeFlags = [
    # see https://github.com/open-dynamic-robot-initiative/master-board/pull/128
    (lib.cmakeBool "BUILD_PYTHON_INTERFACE" stdenv.hostPlatform.isLinux)
  ];

  nativeBuildInputs = [
    jrl-cmakemodules
    python
    cmake
  ];

  # from package.xml
  buildInputs = [ numpy ];

  nativeCheckInputs = [ catch2_3 ];

  propagatedBuildInputs = [ boost ];

  meta = {
    description = "Hardware and Firmware of the Solo Quadruped Master Board";
    homepage = "https://github.com/open-dynamic-robot-initiative/master-board";
    changelog = "https://github.com/open-dynamic-robot-initiative/master-board/blob/master/CHANGELOG.md";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      nim65s
      gwennlbh
    ];
    mainProgram = "master-board";
    platforms = lib.platforms.unix;
  };
}
