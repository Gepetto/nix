{ lib, ... }:
final: prev:
{
  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (
      python-final: python-prev:
      {
        python-qt = python-final.toPythonModule (
          final.python-qt.override { python3 = python-final.python; }
        );

        # https://github.com/NixOS/nixpkgs/pull/549237 merged
        tyro = python-prev.tyro.overrideAttrs {
          patches = [ ./patches/fix-shtab-1.9.patch ];
        };
      }
      // lib.filesystem.packagesFromDirectoryRecursive {
        inherit (python-final) callPackage;
        directory = ./py-pkgs;
      }
    )
  ];

  rosPackages = prev.rosPackages // {
    humble = prev.rosPackages.humble.overrideScope (
      humble-final: _humble-prev:
      final.lib.filesystem.packagesFromDirectoryRecursive {
        inherit (humble-final) callPackage;
        directory = ./ros-pkgs/humble;
      }
    );

    jazzy = prev.rosPackages.jazzy.overrideScope (
      jazzy-final: _jazzy-prev:
      final.lib.filesystem.packagesFromDirectoryRecursive {
        inherit (jazzy-final) callPackage;
        directory = ./ros-pkgs/jazzy;
      }
    );

    kilted = prev.rosPackages.kilted.overrideScope (
      kilted-final: _kilted-prev:
      final.lib.filesystem.packagesFromDirectoryRecursive {
        inherit (kilted-final) callPackage;
        directory = ./ros-pkgs/kilted;
      }
    );

    rolling = prev.rosPackages.rolling.overrideScope (
      rolling-final: _rolling-prev:
      final.lib.filesystem.packagesFromDirectoryRecursive {
        inherit (rolling-final) callPackage;
        directory = ./ros-pkgs/rolling;
      }
    );
  };
}
// lib.filesystem.packagesFromDirectoryRecursive {
  inherit (final) callPackage;
  directory = ./pkgs;
}
