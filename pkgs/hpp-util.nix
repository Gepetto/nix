{
  lib,
  fetchFromGitHub,
  stdenv,
  cmake,
  doxygen,
  jrl-cmakemodules,

  boost,
  tinyxml-2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-util";
  version = "7.0.0";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-util";
    # tag = "v${finalAttrs.version}";
    rev = "release/8.0.0";
    hash = "sha256-Kt3fsjcUPuH9jRPIndJibYVPSM1zw0+NCB8RLTKlFC8=";
  };

  prePatch = ''
    substituteInPlace tests/run_debug.sh.in \
      --replace-fail /bin/bash ${stdenv.shell}
  '';

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

  propagatedBuildInputs = [
    boost
    tinyxml-2
  ];

  doCheck = true;

  meta = {
    description = "Debugging tools for the HPP project";
    homepage = "https://github.com/humanoid-path-planner/hpp-util";
    changelog = "https://github.com/humanoid-path-planner/hpp-util/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
