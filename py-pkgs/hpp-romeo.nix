{
  toPythonModule,
  pkgs,
}:
toPythonModule (
  pkgs.hpp-romeo.override {
    inherit (pkgs) python3Packages;
    pythonSupport = true;
  }
)
