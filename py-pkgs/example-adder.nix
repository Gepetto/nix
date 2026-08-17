{
  toPythonModule,
  pkgs,
}:
toPythonModule (
  (pkgs.example-adder.override {
    pythonSupport = true;
  }).overrideAttrs
    (super: {
      pname = "py-${super.pname}";
    })
)
