{
  lib,

  stdenv,
  fetchFromGitHub,

  # nativeBuildInputs
  cmake,
  doxygen,

  # propagatedBuildInputs
  eigen,
  jrl-cmakemodules,

  # checkInputs
  doctest,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "flex-joints";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "Gepetto";
    repo = "flex-joints";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0+pwVLRoP1rS4MKQwqRIyFmi24ykUbyDslcLnmS+kPw=";
  };

  outputs = [
    "out"
    "doc"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    doxygen
  ];

  buildInputs = [ jrl-cmakemodules ];

  propagatedBuildInputs = [ eigen ];

  checkInputs = [ doctest ];

  cmakeFlags = [ (lib.cmakeBool "BUILD_PYTHON_INTERFACE" false) ];

  doCheck = true;

  meta = {
    changelog = "https://github.com/Gepetto/flex-joints/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Adaptation for rigid control on flexible devices ";
    homepage = "https://github.com/Gepetto/flex-joints";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.unix;
  };
})
