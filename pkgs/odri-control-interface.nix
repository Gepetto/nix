{
  lib,
  fetchFromGitHub,
  stdenv,
  cmake,
  eigen,
  python3Packages,
  yaml-cpp,
  odri-masterboard-sdk,
}:

stdenv.mkDerivation {
  pname = "odri_control_interface";
  # replaced by version from package.xml in the repository's flake
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "gwennlbh";
    repo = "odri_control_interface";
    rev = "nix";
    hash = "sha256-+x+1NxiTwyg5Pwd1oBUMG3Z+eIj+VtVIRFvdPpXStU8=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-warn \
      "cmake_minimum_required(VERSION 3.10)" \
      "cmake_minimum_required(VERSION 3.22)"
  '';

  nativeBuildInputs = [
    odri-masterboard-sdk
    cmake
    eigen
    python3Packages.eigenpy
    python3Packages.boost
    python3Packages.python
  ];

  propagatedBuildInputs = [ yaml-cpp ];

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
}
