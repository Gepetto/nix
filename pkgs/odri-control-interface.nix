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
  pname = "odri-control-interface";
  # replaced by version from package.xml in the repository's flake
  version = "unknown";

  src = src-odri-control-interface;

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail 'set(DEMO_ROOT "''${PROJECT_SOURCE_DIR}/demos")' "set(DEMO_ROOT \"$out/demos\")"
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

  postInstall = ''
    mkdir -p $out/demos
    cp -r demos/* $out/demos
  '';

  meta = {
    description = "Low level control interface";
    homepage = "https://github.com/open-dynamic-robot-initiative/odri_control_interface";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [
      gwennlbh
      nim65s
    ];
    mainProgram = "odri-control-interface";
    platforms = lib.platforms.all;
  };
}
