{
  pkgs,
  toPythonModule,
}:
toPythonModule (pkgs.hpp-practicals.override { inherit (pkgs) python3Packages; })
