{
  pkgs,
  toPythonModule,
}:
toPythonModule (
  (pkgs.hpp-plot.override {
    inherit (pkgs) python3Packages;
  }).overrideAttrs
    (super: {
      pname = "py-${super.pname}";
    })
)
