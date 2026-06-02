{
  pkgs,
  ...
}:
{
  home = {
    username = "cpene";
    homeDirectory = "/home/cpene";
    stateVersion = "25.11";
    packages = [
      pkgs.vcs2l
    ];
  };

  programs.starship.enable = true;
}
