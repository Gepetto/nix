{
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
    bash.enable = true;
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    uv.enable = true;
  };
}
