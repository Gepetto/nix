{
  lib,
  buildRosPackage,

  fetchFromGitHub,

  # nativeBuildInputs
  cmake,
  eigen,
  jrl-cmakemodules,
  python3Packages,
  ament-cmake,
  ament-cmake-cppcheck,
  ament-cmake-cpplint,
  ament-cmake-flake8,
  ament-cmake-pep257,
  ament-cmake-uncrustify,
  rosidl-default-generators,

  # propagatedBuildInputs
  geometry-msgs,
  sensor-msgs,
  tf2-eigen,
}:
let
  version = "1.1.0";
in
buildRosPackage {
  pname = "linear-feedback-controller-msgs";
  inherit version;

  src = fetchFromGitHub {
    owner = "loco-3d";
    repo = "linear-feedback-controller-msgs";
    tag = "v${version}";
    hash = "sha256-XD5NQzgJgfROZcYxaHQHdGD2bEYSorFmmCdi3GbkHtg=";
  };

  nativeBuildInputs = [
    cmake
    eigen
    jrl-cmakemodules
    python3Packages.python
    ament-cmake
    ament-cmake-cppcheck
    ament-cmake-cpplint
    ament-cmake-flake8
    ament-cmake-pep257
    ament-cmake-uncrustify
    rosidl-default-generators
  ];

  propagatedBuildInputs = [
    geometry-msgs
    sensor-msgs
    tf2-eigen
  ];

  doCheck = true;

  meta = {
    description = "ROS messages which correspond to the loco-3d/linear-feedback-controller package.";
    homepage = "https://github.com/loco-3d/linear-feedback-controller-msgs";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.nim65s ];
    platforms = lib.platforms.linux;
  };
}
