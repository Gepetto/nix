{ lib, ... }:
final: prev:
{
  aligator = prev.aligator.overrideAttrs (super: {
    buildInputs = super.buildInputs ++ [ final.mimalloc ];
  });
  eiquadprog = prev.eiquadprog.overrideAttrs {
    # TODO: nixpkgs has it in propagatedBuildInputs, which does not end up in devShell correctly
    buildInputs = [ final.jrl-cmakemodules ];
  };
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
