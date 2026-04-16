{
  lib,
  fetchFromGitHub,
  stdenv,
  cmake,
  doxygen,
  jrl-cmakemodules,

  python3Packages,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-tools";
  version = "8.0.0";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-tools";
    tag = "v${finalAttrs.version}";
    hash = "sha256-exaAcIrDXpiWQXquOh9zy0sVnxgxa+NQlln/j0UJqKE=";
  };

  outputs = [
    "out"
    "doc"
  ];

  nativeBuildInputs = [
    cmake
    doxygen
    python3Packages.python
  ];

  buildInputs = [ jrl-cmakemodules ];

  propagatedBuildInputs = [
    python3Packages.numpy
  ];

  meta = {
    description = "Various tools for hpp";
    homepage = "https://github.com/humanoid-path-planner/hpp-tools";
    changelog = "https://github.com/humanoid-path-planner/hpp-corbaserver/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
