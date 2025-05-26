{
  src-odri-masterboard-sdk,
  stdenv,
  jrl-cmakemodules,
  cmake,
  python312,
  python312Packages,
  catch2_3,
}:

stdenv.mkDerivation rec {
  pname = "odri-masterboard-sdk";
  version = rosVersion ./sdk/master_board_sdk/package.xml;

  src = src-odri-masterboard-sdk;
  # TODO put this in src-odri-masterboard-sdk somehow?
  sourceRoot = "${src.name}/sdk/master_board_sdk";

  doCheck = true;

  nativeBuildInputs = [
    jrl-cmakemodules
    cmake
    python312
  ];

  # from package.xml
  buildInputs = with python312Packages; [ numpy ];

  nativeCheckInputs = [ catch2_3 ];

  propagatedBuildInputs = with python312Packages; [ boost ];
}
