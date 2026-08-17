{
  lib,
  fetchFromGitHub,
  stdenv,

  # nativeBuildInputs
  odri-masterboard-sdk,
  python3Packages,

  # buildInputs
  jrl-cmakemodules,
  eigen,

  # propagatedBuildInputs
  yaml-cpp,

  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "odri-control-interface";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "gwennlbh";
    repo = "odri_control_interface";
    rev = "nix";
    hash = "sha256-+x+1NxiTwyg5Pwd1oBUMG3Z+eIj+VtVIRFvdPpXStU8=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail \
      "cmake_minimum_required(VERSION 3.10)" \
      "cmake_minimum_required(VERSION 3.22)"
  '';

  nativeBuildInputs = jrl-cmakemodules.docsNativeBuildInputs ++ [
    odri-masterboard-sdk
    eigen
    python3Packages.eigenpy
    python3Packages.boost
    python3Packages.python
  ];

  buildInputs = [
    jrl-cmakemodules
  ];

  propagatedBuildInputs = [
    yaml-cpp
  ];

  cmakeFlags = jrl-cmakemodules.docsCmakeFlags ++ [
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.doCheck)
  ];

  doCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Low level control interface";
    homepage = "https://github.com/open-dynamic-robot-initiative/odri_control_interface";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      gwennlbh
      nim65s
    ];
    mainProgram = "odri-control-interface";
    platforms = lib.platforms.unix;
  };
})
