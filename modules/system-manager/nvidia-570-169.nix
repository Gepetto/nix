{ pkgs, ... }:
{
  imports = [ ./nvidia.nix ];

  system-graphics.package =
    (pkgs.linuxPackages.nvidiaPackages.mkDriver {
      version = "570.169";
      sha256_64bit = "sha256-XzKoR3lcxcP5gPeRiausBw2RSB1702AcAsKCndOHN2U=";
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
