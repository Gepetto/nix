{ lib, ... }:
final: prev:
{
  # https://github.com/NixOS/nixpkgs/pull/519501
  proxsuite = prev.proxsuite.overrideAttrs (super: {
    version = "0.7.3";
    src = final.fetchFromGitHub {
      inherit (super.src) owner repo rev;
      hash = "sha256-qJZQV9vNLQ/rtPMRdAfjwrYExyyDC2OP8uVeywkQ56Y=";
    };
    postPatch = "";
  });
  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (_python-final: python-prev: {
      aerosandbox = python-prev.aerosandbox.overrideAttrs {
        pythonRemoveDeps = [
          # infinite recursion
          "neuralfoil"
          # not pypa-installed, so no metadata
          # good candidate for https://github.com/NixOS/nixpkgs/pull/518530
          "casadi"
        ];
      };
      daqp = python-prev.daqp.overrideAttrs (
        finalAttrs: prevAttrs: {
          version = "0.8.4";
          src = final.fetchFromGitHub {
            inherit (prevAttrs.src) owner repo;
            tag = "v${finalAttrs.version}";
            hash = "sha256-UakuHHsz4LXDfI7+VT5TO+jg90gpgu3lTJL8RGhtODQ=";
          };
          sourceRoot = "${finalAttrs.src.name}/interfaces/daqp-python";
          postPatch = ''
            substituteInPlace setup.py --replace-fail \
            "if src_path.exists():" \
            "if False:"
          '';
        }
      );
      qpsolvers = python-prev.qpsolvers.overrideAttrs (
        finalAttrs: prevAttrs: {
          version = "4.12.0";
          src = final.fetchFromGitHub {
            inherit (prevAttrs.src) owner repo;
            tag = "v${finalAttrs.version}";
            hash = "sha256-KUaDas2PIkTuy+Yi94vKm1P/n6QLPDcUXm8KjOq6JzI=";
          };
        }
      );
    })
  ];
}
// {
  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (
      python-final: _python-prev:
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
