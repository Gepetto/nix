{ pkgs, ... }:
{
  imports = [ ./nvidia.nix ];

  system-graphics.package =
    (pkgs.linuxPackages.nvidiaPackages.mkDriver {
      version = "580.159.03";
      sha256_64bit = "sha256-MshdmbD2QMlQH2GzndrSCP0CiNAVxPvF/QQ1wHeD+nc=";
      sha256_aarch64 = "";
      openSha256 = "";
      settingsSha256 = "";
      persistencedSha256 = "";
      patches = pkgs.linuxPackages.nvidiaPackages.stable.patches;
    }).override
      {
        libsOnly = true;
      };
}
