{
  lib,
  pkgs,
  ...
}:
let
  electron = pkgs.electron_42;
  electron-wrapped-suid = pkgs.stdenvNoCC.mkDerivation {
    name = "electron-wrapped-suid";
    dontUnpack = true;
    installPhase = ''
      mkdir -p $out/bin
      cp ${lib.getExe electron} $out/bin/
      sed -i \
        "s|export CHROME_DEVEL_SANDBOX='.*'|export CHROME_DEVEL_SANDBOX='/run/wrappers/bin/electron-chrome-sandbox'|" \
        $out/bin/electron
    '';
    meta.mainProgram = "electron";
  };
  element-desktop-wrapped-suid = pkgs.stdenvNoCC.mkDerivation {
    name = "element-desktop-wrapped-suid";
    dontUnpack = true;
    installPhase = ''
      mkdir -p $out/bin
      cp ${lib.getExe pkgs.element-desktop} $out/bin/
      sed -i \
        's|exec "/nix/store/s2cfqg9q7ki55k5rfs88mr8smg00yfpl-electron-42.7.1/bin/electron"|exec "${lib.getExe electron-wrapped-suid}"|' \
        $out/bin/element-desktop
    '';
    meta.mainProgram = "element-desktop";
  };
in
{
  imports = [
    ./direnv.nix
    ./path.nix
  ];
  environment.systemPackages = [
    element-desktop-wrapped-suid
  ];
  nixpkgs.hostPlatform = "x86_64-linux";
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  security.wrappers = {
    electron-chrome-sandbox = {
      owner = "root";
      group = "root";
      setuid = true;
      source = "${electron}/libexec/electron/chrome-sandbox";
    };
    ping = {
      owner = "root";
      group = "root";
      capabilities = "cap_net_raw+ep";
      source = lib.getExe' pkgs.iputils.out "ping";
    };
  };
  system-graphics.enable = true;
}
