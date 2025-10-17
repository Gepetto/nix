{
  lib,
  runCommand,
  makeWrapper,
  toPythonModule,
  gepetto-viewer,
  gepetto-viewer-corba,
  hpp-gepetto-viewer,
  hpp-gui,
}:
let
  plugins = [
    gepetto-viewer-corba
    hpp-gepetto-viewer
    hpp-gui
  ];
in
toPythonModule (
  # TODO: use finalPackage in nixpkgs
  runCommand "gepetto-gui"
    {
      inherit (gepetto-viewer) version;
      pname = "gepetto-gui";
      meta = {
        # can't just "inherit (gepetto-viewer) meta;" because:
        # error: derivation '/nix/store/…-gepetto-gui.drv' does not have wanted outputs 'bin'
        inherit (gepetto-viewer.meta)
          description
          homepage
          license
          maintainers
          mainProgram
          platforms
          ;
      };
      nativeBuildInputs = [ makeWrapper ];
      propagatedBuildInputs = plugins;
    }
    ''
      makeWrapper ${lib.getExe gepetto-viewer} $out/bin/gepetto-gui \
        --set GEPETTO_GUI_PLUGIN_DIRS ${lib.makeLibraryPath plugins}
    ''
)
