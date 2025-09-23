{
  toPythonModule,
  pkgs,
}:
toPythonModule (
  pkgs.flex-joints.override {
    inherit (pkgs) python3Packages;
    pythonSupport = true;
  }
)
