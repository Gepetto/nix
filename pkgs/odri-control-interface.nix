{

  src-odri-control-interface,

  stdenv,
  cmake,
  eigen,
  python312Packages,
  python312,
  yaml-cpp,
  odri-masterboard-sdk,
}:

stdenv.mkDerivation {
  pname = "odri-control-interface";
  # replaced by version from package.xml in the repository's flake
  version = "unknown";

  src = src-odri-control-interface;

  nativeBuildInputs = [
    odri-masterboard-sdk
    cmake
    eigen
    python312Packages.eigenpy
    python312Packages.boost
    python312
  ];

  propagatedBuildInputs = [ yaml-cpp ];
}
