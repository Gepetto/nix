{ lib, ... }:
final: prev:
{
  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (
      python-final: python-prev:
      {
        aligator = python-prev.aligator.overrideAttrs (super: {
          nativeCheckInputs = (super.nativeBuildInputs or [ ]) ++ [ final.ctestCheckHook ];
          disabledTests =
            (super.disabledTests or [ ])
            ++ lib.optionals final.stdenv.hostPlatform.isDarwin [
              # SIGTRAP on GHA
              "aligator-test-py-mpc"
            ];
        });
        brax = python-prev.brax.overrideAttrs {
          # because keras
          doInstallCheck = false;
        };
        keras = python-prev.keras.overrideAttrs {
          # WTF ?
          doInstallCheck = false;
        };
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
