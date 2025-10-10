{
  toPythonModule,
  pkgs,
}:
toPythonModule (
  pkgs.aig.override {
    inherit (pkgs) python3Packages;
    pythonSupport = true;
  }
)
