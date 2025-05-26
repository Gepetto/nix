{

  src-odri-control,

  stdenv,
  cmake,
  eigen,
  python312Packages,
  python312,
  yaml-cpp,
  odri-masterboard-sdk,
}:

stdenv.mkDerivation rec {
  pname = "odri-control";
  # replaced by version from package.xml in the repository's flake
  version = "unknown";

  src = src-odri-control;

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
