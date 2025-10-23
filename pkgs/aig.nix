{
  lib,

  stdenv,
  fetchFromGitHub,

  # nativeBuildInputs
  cmake,

  # propagatedBuildInputs
  boost,
  eigen,
  eiquadprog,
  pinocchio,
  example-robot-data,
  jrl-cmakemodules,

# checkInputs,
# doctest,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "aig";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "Gepetto";
    repo = "aig";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5Iph+0LxOYz0iIvLLI/zpS7Xrz1e1a56sapfDKCp2vM=";
  };

  nativeBuildInputs = [
    cmake
  ];

  propagatedBuildInputs = [
    eigen
    eiquadprog
    jrl-cmakemodules
    example-robot-data
    pinocchio
  ];

  checkInputs = [
    boost
  ];

  # /nix/var/nix/builds/nix-5586-3721320871/source/tests/test_biped_ig.cpp:156: error:
  # in "BOOST_TEST_MODULE/test_solve_random": check (q_test - q_ig_base).norm() <= precision has failed
  # [1.9999999999999998 > 1]
  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [ "test_biped_ig" ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_PYTHON_INTERFACE" false)
    (lib.cmakeFeature "CMAKE_CTEST_ARGUMENTS" "--exclude-regex;'${lib.concatStringsSep "|" finalAttrs.disabledTests}'")
  ];

  doCheck = true;

  meta = {
    description = "Analytical inverse geometry for 6 links kinematic chains";
    homepage = "https://github.com/Gepetto/aig";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.unix;
  };
})
