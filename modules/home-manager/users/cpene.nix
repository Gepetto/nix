{ pkgs, ... }:
{
  programs.starship.enable = true;
  home.packages = [ pkgs.git-lfs ];
}
