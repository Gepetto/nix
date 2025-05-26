{
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

  src = fetchgit {
    url = "https://github.com/open-dynamic-robot-initiative/odri_control_interface";
    rev = "v${version}";
    hash = "sha256-NGsgrSyhD2fFTm/IqgdqXw7aMEwD7QSsPDhjDm+50qQ=";
  };

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
