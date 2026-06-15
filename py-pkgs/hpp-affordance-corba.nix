{
  toPythonModule,
  pkgs,
}:
toPythonModule (
  (pkgs.hpp-affordance-corba.override {
    inherit (pkgs) python3Packages;
  }).overrideAttrs
    (super: {
      pname = "py-${super.pname}";
    })
)
