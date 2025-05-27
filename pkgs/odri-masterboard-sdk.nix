{
  src-odri-masterboard-sdk,
  stdenv,
  jrl-cmakemodules,
  cmake,
  python3Packages,
  catch2_3,
}:

stdenv.mkDerivation {
  pname = "odri-masterboard-sdk";
  # replaced by version from package.xml in the repository's flake
  version = "unknown";

  src = src-odri-masterboard-sdk;

  # TODO sourceRoot = "${src.name}/sdk/master_board_sdk"; when we'll switch to fetchFromGitHub
  preConfigure = ''
    cd sdk/master_board_sdk
  '';
  doCheck = true;

  nativeBuildInputs = [
    jrl-cmakemodules
    python3Packages.python
    cmake
  ];

  # from package.xml
  buildInputs = with python3Packages; [ numpy ];

  nativeCheckInputs = [ catch2_3 ];

  propagatedBuildInputs = with python3Packages; [ boost ];
}
