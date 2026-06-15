{
  pkgs,
  toPythonModule,
}:
toPythonModule (
  (pkgs.hpp-doc.override {
    inherit (pkgs) python3Packages;
  }).overrideAttrs
    (super: {
      pname = "py-${super.pname}";
    })
)
