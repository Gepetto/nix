{
  toPythonModule,
  pkgs,
}:
toPythonModule (
  pkgs.multicontact-api.override {
    inherit (pkgs) python3Packages;
    pythonSupport = true;
  }
)
