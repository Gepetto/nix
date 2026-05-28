{
  toPythonModule,
  pkgs,
}:
toPythonModule (
  pkgs.example-adder.override {
    inherit (pkgs) python3Packages;
    pythonSupport = true;
  }
)
