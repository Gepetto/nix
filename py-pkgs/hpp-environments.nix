{
  toPythonModule,
  pkgs,
}:
toPythonModule (
  (pkgs.hpp-environments.override {
    inherit (pkgs) python3Packages;
    pythonSupport = true;
  }).overrideAttrs
    (super: {
      pname = "py-${super.pname}";
    })
)
