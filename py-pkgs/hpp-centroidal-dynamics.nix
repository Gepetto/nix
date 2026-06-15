{
  toPythonModule,
  pkgs,
}:
toPythonModule (
  (pkgs.hpp-centroidal-dynamics.override {
    inherit (pkgs) python3Packages;
    pythonSupport = true;
  }).overrideAttrs
    (super: {
      pname = "py-${super.pname}";
    })
)
