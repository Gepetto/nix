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
  version = rosVersion ./package.xml;

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
