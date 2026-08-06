{
  toPythonModule,
  pkgs,
}:
toPythonModule (
  (pkgs.hpp-exec.override {
    inherit (pkgs) python3Packages;
  }).overrideAttrs
    (super: {
      pname = "py-${super.pname}";
    })
)
