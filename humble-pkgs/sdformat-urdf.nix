# Copyright 2025 Open Source Robotics Foundation
# Distributed under the terms of the BSD license

{
  lib,
  buildRosPackage,
  fetchurl,
  ament-cmake-gtest,
  ament-cmake-ros,
  ament-lint-auto,
  ament-lint-common,
  pluginlib,
  rcutils,
  sdformat_14,
  sdformat-test-files,
  tinyxml2-vendor,
  urdf,
  urdf-parser-plugin,
  urdfdom-headers,
  python-with-ament-package,
}:
buildRosPackage {
  pname = "ros-humble-sdformat-urdf";
  version = "1.0.1-r1";

  src = fetchurl {
    url = "https://github.com/ros2-gbp/sdformat_urdf-release/archive/release/humble/sdformat_urdf/1.0.1-1.tar.gz";
    name = "1.0.1-1.tar.gz";
    hash = "sha256-DMMtrspefTiou5xnzeWx60UsqzAhJ+h9VCHbfMahhqw=";
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt --replace-fail \
      "sdformat12" \
      "sdformat14"
  '';

  checkInputs = [
    ament-cmake-gtest
    ament-lint-auto
    ament-lint-common
    sdformat-test-files
  ];
  propagatedBuildInputs = [
    ament-cmake-ros
    pluginlib
    rcutils
    sdformat_14
    tinyxml2-vendor
    urdf
    urdf-parser-plugin
    urdfdom-headers
  ];
  nativeBuildInputs = [
    ament-cmake-ros
  ];

  env = {
    GZ_VERSION = "harmonic";
    PYTHONPATH = python-with-ament-package;
  };

  meta = {
    description = "URDF plugin to parse SDFormat XML into URDF C++ DOM objects.";
    license = with lib.licenses; [ asl20 ];
  };
}
