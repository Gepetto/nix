{
  src-odri-control-interface,

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

  nativeBuildInputs = [
    odri-masterboard-sdk
    cmake
    eigen
    python3Packages.eigenpy
    python3Packages.boost
    python3Packages.python
  ];

  propagatedBuildInputs = [ yaml-cpp ];
}
