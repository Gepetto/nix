{
  pkgs,
  toPythonModule,
}:
toPythonModule (pkgs.hpp-gepetto-viewer.override { inherit (pkgs) python3Packages; })
