# required by inspire-hand-ws
{
  pymodbus,
  fetchFromGitHub,
}:
pymodbus.overrideAttrs (
  drv-final: drv-prev: {
    version = "3.6.9";
    src = fetchFromGitHub {
      inherit (drv-prev.src) owner repo;
      tag = "v${drv-final.version}";
      hash = "sha256-ScqxDO0hif8p3C6+vvm7FgSEQjCXBwUPOc7Y/3OfkoI=";
    };
    disabledTestPaths = [ ];
  }
)
