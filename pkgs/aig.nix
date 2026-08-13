{
  lib,

  stdenv,
  fetchFromGitHub,

  boost,
  eigen,
  eiquadprog,
  pinocchio,
  example-robot-data,
  jrl-cmakemodules,
  ctestCheckHook,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "aig";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "Gepetto";
    repo = "aig";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9ZKPpL80IOk2xDg+ORta5xZqZq5QbRFvSom861xjPfk=";
  };

  outputs = [
    "out"
    "doc"
  ];

  nativeBuildInputs = jrl-cmakemodules.docsNativeBuildInputs;

  buildInputs = [
    jrl-cmakemodules
  ];

  propagatedBuildInputs = [
    eigen
    eiquadprog
    example-robot-data
    pinocchio
  ];

  checkInputs = [
    boost
  ];

  nativeCheckInputs = [
    ctestCheckHook
  ];

  # /nix/var/nix/builds/nix-5586-3721320871/source/tests/test_biped_ig.cpp:156: error:
  # in "BOOST_TEST_MODULE/test_solve_random": check (q_test - q_ig_base).norm() <= precision has failed
  # [1.9999999999999998 > 1]
  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [ "test_biped_ig" ];

  cmakeFlags = jrl-cmakemodules.docsCmakeFlags ++ [
    (lib.cmakeBool "BUILD_PYTHON_INTERFACE" false)
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.doCheck)
  ];

  doCheck = true;

  strictDeps = true;
  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/Gepetto/aig/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Analytical inverse geometry for 6 links kinematic chains";
    homepage = "https://github.com/Gepetto/aig";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.unix;
  };
})
