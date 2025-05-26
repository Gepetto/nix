{
  stdenv,
  fetchFromGithub,
  jrl-cmakemodules,
  cmake,
  python312,
  python312Packages,
  catch2_3,
}:

stdenv.mkDerivation {
  pname = "odri-masterboard-sdk";
  version = rosVersion ./sdk/master_board_sdk/package.xml;

  src = fetchgit {
    url = "https://github.com/open-dynamic-robot-initiative/master-board";
    rev = version;
    hash = "sha256-3vx3bOQkFnZXZ4jSh89Se7T8t6VpfL+JV3sVHz8+X78=";
    sparseCheckout = [
      "sdk/master_board_sdk"
    ];
  };

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
