{
  src-odri-control-interface,

  lib,
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

  src = src-odri-control-interface;

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
