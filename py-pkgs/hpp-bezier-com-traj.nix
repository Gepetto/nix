{
  toPythonModule,
  pkgs,
}:
toPythonModule (
  (pkgs.hpp-bezier-com-traj.override {
    inherit (pkgs) python3Packages;
    pythonSupport = true;
  }).overrideAttrs
    (super: {
      pname = "py-${super.pname}";
    })
)
