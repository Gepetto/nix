{
  toPythonModule,
  pkgs,
}:
toPythonModule (
  (pkgs.toppra.override {
    inherit (pkgs) python3Packages;
  }).overrideAttrs
    (super: {
      pname = "py-${super.pname}";
    })
)
