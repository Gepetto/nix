# Gepetto Nix

This project is a flake which provide packages and development environment to gepetto members.

## Binary cache

ref. <https://gepetto.cachix.org>

The goal is to make use of ros.cachix.org, but right now (2024-12-09), this is complicated.

## NixGL

This is for now mostly intended for people not running NixOS, so nixGL is used.
Therefore, for nix-direnv, you probably need something like:
```bash
echo 'use flake . --impure' > .envrc
```

NB: if you have nvidia hardware, you'll also need `export NIXPKGS_ALLOW_UNFREE=1`

## Pure

If you are on NixOS, or can manage OpenGL on your own, and want to avoid such impurity:
```bash
echo 'use flake .#pure' > .envrc
```

Also, that one is used for CI and cache.
