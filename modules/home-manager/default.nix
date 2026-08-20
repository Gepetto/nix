{
  lib,
  home-manager,
  nixpkgs,
  ...
}:
lib.mapAttrs
  (
    username: config:
    home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      extraSpecialArgs = { inherit username; };
      modules = [
        ./home.nix
        config
      ];
    }
  )
  {
    cpene = ./users/cpene.nix;
  }
