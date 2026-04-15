{
  toPythonModule,
  pkgs,
}:
toPythonModule (
  pkgs.hpp-toppra.override {
    inherit (pkgs) python3Packages;
  }
)
