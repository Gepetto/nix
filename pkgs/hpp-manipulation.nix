{
  lib,
  fetchFromGitHub,
  fetchpatch,
  stdenv,

  # nativeBuildInputs
  cmake,
  doxygen,
  pkg-config,

  # propagatedBuildInputs
  hpp-core,
  hpp-universal-robot,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hpp-manipulation";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "humanoid-path-planner";
    repo = "hpp-manipulation";
    tag = "v${finalAttrs.version}";
    hash = "sha256-O8eUPabhuVpNEG66scfiX49LIuZzNWNK6WEHL5cK+tQ=";
  };

  # https://github.com/humanoid-path-planner/hpp-manipulation/pull/191
  # required for hpp-manipulation-urdf devel
  patches = [
    (fetchpatch {
      url = "https://github.com/humanoid-path-planner/hpp-manipulation/pull/191/commits/5c1baa6faab6307b04002dfeb91d8902856391b5.patch";
      hash = "sha256-C4UOzlVLLwYQ0hNw7c8py8iGKCCpMt2KQTs28aRtbak=";
    })
    (fetchpatch {
      url = "https://github.com/humanoid-path-planner/hpp-manipulation/pull/191/commits/db478644c80b44c5d13715ce402b5a1b5db4e6a2.patch";
      hash = "sha256-p/Q3yHSOvEreX6sdjKRdDFIj429gdsQDkZ0nDWhKlwo=";
    })
    (fetchpatch {
      url = "https://github.com/humanoid-path-planner/hpp-manipulation/pull/191/commits/a74ec2db40da335265a99736f1b4708c6063d57c.patch";
      hash = "sha256-ykIUsUkm7W1yDDjLJOn+IOtf5aS9vNAf068pVw+fixM=";
    })
    (fetchpatch {
      url = "https://github.com/humanoid-path-planner/hpp-manipulation/pull/191/commits/f49153ff11e0940631e6adf21ca751c81fa259c0.patch";
      hash = "sha256-Rju/XHjXvtkemku/Bm2onK9UdQIIyQFqbJ6w5GdtRks=";
    })
  ];

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-warn \
      "cmake_minimum_required(VERSION 3.10)" \
      "cmake_minimum_required(VERSION 3.22)"
  '';

  outputs = [
    "out"
    "doc"
  ];

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    doxygen
    pkg-config
  ];
  propagatedBuildInputs = [
    hpp-core
    hpp-universal-robot
  ];

  doCheck = true;

  meta = {
    description = "Classes for manipulation planning";
    homepage = "https://github.com/humanoid-path-planner/hpp-manipulation";
    changelog = "https://github.com/humanoid-path-planner/hpp-manipulation/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.unix;
  };
})
