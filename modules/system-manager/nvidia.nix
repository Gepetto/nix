{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    gepetto-nvidia = {
      version = lib.mkOption {
        description = "nvidia driver version";
        default = "";
        type = lib.types.str;
      };
      sha256_64bit = lib.mkOption {
        description = "nvidia driver hash";
        default = "";
        type = lib.types.str;
      };
    };
  };

  config = {

    nixpkgs.config.allowUnfree = true;
    system-graphics.package =
      (pkgs.linuxPackages.nvidiaPackages.mkDriver {
        inherit (config.gepetto-nvidia) version sha256_64bit;
        sha256_aarch64 = "";
        openSha256 = "";
        settingsSha256 = "";
        persistencedSha256 = "";
        patches = pkgs.linuxPackages.nvidiaPackages.stable.patches;
      }).override
        {
          libsOnly = true;
        };
  };
}
