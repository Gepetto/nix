{ pkgs, ... }:
{
  imports = [ ./nvidia.nix ];

  system-graphics.package =
    (pkgs.linuxPackages.nvidiaPackages.mkDriver {
      version = "535.309.01";
      sha256_64bit = "sha256-KItJAup5sBe0mpImqE9+qj5rScoBRq5QJ3wv4Z3TmAM=";
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
