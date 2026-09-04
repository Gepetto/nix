# Gepetto Nix

This project is a flake which provide packages and development environment to gepetto members.

## Binary cache

ref. <https://gepetto.cachix.org>

## System

```
nix run github:gepetto/nix#system-manager -- switch --sudo --flake github:gepetto/nix
```

## Home

```
nix run github:gepetto/nix#home-manager -- switch --flake github:gepetto/nix -b hmback
```
