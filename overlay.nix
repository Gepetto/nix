{ lib, ... }:
final: prev:
{
  aligator = prev.aligator.overrideAttrs (super: {
    version = "0.19.0";
    src = final.fetchFromGitHub {
      inherit (super.src) owner repo tag;
      hash = "sha256-8DO+lfM4mk4bA/IOEJlLaOp9snCUBHiw7RRcYEwJC7c=";
    };
    buildInputs = super.buildInputs ++ [ final.mimalloc ];
    # wait for https://github.com/NixOS/nixpkgs/pull/506375
    postPatch = ''
      substituteInPlace bench/lqr.cpp bench/se2-car.cpp bench/talos-walk.cpp bench/croc-talos-arm.cpp bench/gar-riccati.cpp \
        --replace-fail benchmark::Benchmark benchmark::internal::Benchmark
    '';
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
