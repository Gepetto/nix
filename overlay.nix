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
      }
      // lib.filesystem.packagesFromDirectoryRecursive {
        inherit (python-final) callPackage;
        directory = ./py-pkgs;
      }
    )
  ];
}
// lib.filesystem.packagesFromDirectoryRecursive {
  inherit (final) callPackage;
  directory = ./pkgs;
}
