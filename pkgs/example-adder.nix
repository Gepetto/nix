{
  lib,
  stdenv,
  fetchFromGitHub,
  boost,
  jrl-cmakemodules,
  python3Packages,
  pythonSupport ? false,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "example-adder";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "Gepetto";
    repo = "example-adder";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zwHvjDxisiwUgaAgasHgk4LCzqGCxbtBOehcedH1Kw8=";
  };

  outputs = [
    "dev"
    "doc"
    "out"
  ];

  nativeBuildInputs =
    jrl-cmakemodules.docsNativeBuildInputs ++ lib.optional pythonSupport python3Packages.python;

  buildInputs = [
    jrl-cmakemodules
  ]
  ++ lib.optionals pythonSupport [
    python3Packages.python
    python3Packages.boost
  ];

  checkInputs = lib.optional (!pythonSupport) boost;

  cmakeFlags = jrl-cmakemodules.docsCmakeFlags ++ [
    (lib.cmakeBool "BUILD_PYTHON_INTERFACE" pythonSupport)
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.doCheck)
  ];

  doCheck = true;

  strictDeps = true;
  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "This is an example project, to show how to use Gepetto's tools";
    homepage = "https://github.com/Gepetto/example-adder";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ nim65s ];
    mainProgram = "example-adder";
    platforms = lib.platforms.unix;
  };
})
