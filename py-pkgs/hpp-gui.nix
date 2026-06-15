{
  pkgs,
  toPythonModule,
}:
toPythonModule (
  (pkgs.hpp-gui.override {
    inherit (pkgs) python3Packages;
  }).overrideAttrs
    (super: {
      pname = "py-${super.pname}";
    })
)
