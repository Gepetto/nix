{
  src-odri-masterboard-sdk,

  lib,
  stdenv,
  jrl-cmakemodules,
  cmake,
  python3Packages,
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
    python3Packages.python
    cmake
  ];

  # from package.xml
  buildInputs = with python3Packages; [ numpy ];

  nativeCheckInputs = [ catch2_3 ];

  propagatedBuildInputs = with python3Packages; [ boost ];

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
