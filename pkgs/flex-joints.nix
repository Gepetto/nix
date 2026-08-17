{
  lib,

  stdenv,
  fetchFromGitHub,

  # buildInputs
  eigen,
  jrl-cmakemodules,

  # checkInputs
  doctest,

  nix-update-script,
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

  nativeBuildInputs = jrl-cmakemodules.docsNativeBuildInputs;

  buildInputs = [
    jrl-cmakemodules
    eigen
  ];

  checkInputs = [
    doctest
  ];

  cmakeFlags = jrl-cmakemodules.docsCmakeFlags ++ [
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.doCheck)
    (lib.cmakeBool "BUILD_PYTHON_INTERFACE" false)
  ];

  doCheck = true;

  strictDeps = true;
  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/Gepetto/flex-joints/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Adaptation for rigid control on flexible devices ";
    homepage = "https://github.com/Gepetto/flex-joints";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ nim65s ];
    platforms = lib.platforms.unix;
  };
})
