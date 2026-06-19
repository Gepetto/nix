{ pkgs, ... }:
{
  imports = [ ./nvidia.nix ];

  system-graphics.package =
    (pkgs.linuxPackages.nvidiaPackages.mkDriver {
      version = "595.71.05";
      sha256_64bit = "sha256-NiA7iWC35JyKQva6H1hjzeNKBek9KyS3mK8G3YRva4I=";
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
