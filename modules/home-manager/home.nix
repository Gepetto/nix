{
  lib,
  pkgs,
  username,
  ...
}:
{
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
    packages = [
      pkgs.vcs2l
    ];
    stateVersion = "26.11";
  };

  programs = {
    bash = {
      enable = true;
      initExtra = ''
        eval "$(${lib.getExe' pkgs.python3Packages.argcomplete "register-python-argcomplete"} colcon ros2)"
      '';
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    uv.enable = true;
  };
}
