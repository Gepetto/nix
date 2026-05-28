{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  doxygen,
  jrl-cmakemodules,
  pkg-config,
  python3Packages,
  pythonSupport ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "example-adder";
  version = "4.1.1";

  src = fetchFromGitHub {
    owner = "Gepetto";
    repo = "example-adder";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rhkMS0J9QzD7C16jLi0kbhV07JY/uScFCma6yKHZ2Kw=";
  };

  nativeBuildInputs = [
    cmake
    doxygen
    pkg-config
  ];

  buildInputs = [
    jrl-cmakemodules
  ]
  ++ lib.optionals pythonSupport [
    python3Packages.python
    python3Packages.boost
  ];

  checkInputs = lib.optional (!pythonSupport) boost;

  cmakeFlags = [ (lib.cmakeBool "BUILD_PYTHON_INTERFACE" pythonSupport) ];

  outputs = [
    "dev"
    "doc"
    "out"
  ];

  doCheck = true;

  meta = {
    description = "This is an example project, to show how to use Gepetto's tools";
    homepage = "https://github.com/Gepetto/example-adder";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ nim65s ];
    mainProgram = "example-adder";
    platforms = lib.platforms.unix;
  };
})
