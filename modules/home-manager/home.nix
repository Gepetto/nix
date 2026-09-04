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

    bat.enable = true;

    btop.enable = true;

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    element-desktop = {
      enable = true;
      package = null; # use suid wrapped one from system-manager
      settings = {
        default_server_config."m.homeserver" = {
          base_url = "https://matrix.laas.fr";
          server_name = "laas.fr";
        };
      };
    };

    fd.enable = true;

    git = {
      enable = true;
      lfs.enable = true;
    };

    ripgrep.enable = true;

    ssh = {
      enable = true;
      enableDefaultConfig = false; # deprecated opinionatied settings from home-manager
      settings = {
        # https://intranet.laas.fr/fr/catalogue-des-services/utilisation-de-ssh-sous-linux/
        "*" = {
          userKnownHostsFile = pkgs.writeText "laas-ssh-cert" ''
            @cert-authority *,*.laas.fr ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMTrrfJG//e07Ia9i9dEsl8oQN5ibOIaXd4YanZiGGLd
          '';
        };
        "*.laas.fr !ssh.laas.fr" = {
          proxyJump = "ssh.laas.fr";
          controlMaster = "auto";
          controlPersist = 180;
          controlPath = "~/.ssh/C-%C";
          ForwardAgent = true;
        };
      };
    };

    swaylock.package = null; # wont work with ldap, use the one from ubuntu

    uv.enable = true;

    zellij.enable = true;
  };

  services.home-manager = {
    autoExpire = {
      enable = true;
      frequency = "weekly";
      store.cleanup = true;
      store.options = "--delete-older-than 30d";
    };
    autoUpgrade = {
      enable = true;
      flakeUrl = "github:gepetto/nix";
      frequency = "weekly";
      useFlake = true;
      flags = [
        "-b"
        "hmback"
      ];
    };
  };
}
