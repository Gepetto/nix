{
  lib,
  nix-system-graphics,
  system-manager,
  ...
}:
let
  hosts = lib.importJSON ./hosts.json;
  hashes = lib.importJSON ./hashes.json;
in
{
  default = system-manager.lib.makeSystemConfig {
    modules = [
      nix-system-graphics.systemModules.default
      ./shared.nix
    ];
  };
}
// lib.genAttrs (lib.attrNames hosts) (
  name:
  let
    version = hosts."${name}";
    sha256_64bit = hashes."${version}" or "";
  in
  system-manager.lib.makeSystemConfig {
    modules = [
      nix-system-graphics.systemModules.default
      ./shared.nix
      ./nvidia.nix
      ({
        gepetto-nvidia = { inherit version sha256_64bit; };
      })
    ];
  }
)
