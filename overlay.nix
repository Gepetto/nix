{ lib, ... }:
final: prev:
{
  aligator =
    assert (!lib.versionAtLeast prev.aligator.version "0.19.0");
    prev.aligator.overrideAttrs (super: {
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
  crocoddyl =
    assert (!lib.versionAtLeast prev.crocoddyl.version "3.2.1");
    prev.crocoddyl.overrideAttrs (super: {
      version = "3.2.1";
      src = final.fetchFromGitHub {
        inherit (super.src) repo tag;
        owner = "nim65s";
        hash = "sha256-7L4S9DQ470pTXARBuerahO9LD1LQfYOZGrYAZalMPUs=";
      };
    });
  eiquadprog =
    assert (!lib.versionAtLeast prev.eiquadprog.version "1.3.2");
    prev.eiquadprog.overrideAttrs (
      finalAttrs: prevAttrs: {
        # TODO: nixpkgs has it in propagatedBuildInputs, which does not end up in devShell correctly
        buildInputs = [ final.jrl-cmakemodules ];
        version = "1.3.2";
        src = final.fetchFromGitHub {
          inherit (prevAttrs.src) owner repo;
          tag = "v${finalAttrs.version}";
          hash = "sha256-ukYIc5ZCIDunXMyC44Dd1qac4Ku4pNv9p4ik+xyI0i0=";
        };
      }
    );
  pinocchio =
    assert (!lib.versionAtLeast prev.pinocchio.version "4.0.0");
    prev.pinocchio.overrideAttrs (
      finalAttrs: prevAttrs: {
        version = "4.0.0";
        src = final.fetchFromGitHub {
          inherit (prevAttrs.src) owner repo;
          tag = "v${finalAttrs.version}";
          hash = "sha256-9UnMGrs4mvBYfjmwOprhqStRW/liPrsKFabRFE2xmjo=";
        };
      }
    );
  tsid =
    assert (!lib.versionAtLeast prev.tsid.version "1.10.0");
    prev.tsid.overrideAttrs (
      finalAttrs: prevAttrs: {
        version = "1.10.0";
        src = final.fetchFromGitHub {
          inherit (prevAttrs.src) owner repo;
          tag = "v${finalAttrs.version}";
          hash = "sha256-f/SecQfEmrlelVR5584KIHFwwrp5Cy2aBMKI/rxuPmc=";
        };
      }
    );
  pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
    (
      python-final: python-prev:
      {
        aligator = python-prev.aligator.overrideAttrs (super: {
          nativeCheckInputs = (super.nativeBuildInputs or [ ]) ++ [ final.ctestCheckHook ];
          disabledTests =
            (super.disabledTests or [ ])
            ++ [
              # works in pinocchio 3, not 4.
              # reported in https://github.com/Simple-Robotics/aligator/pull/404
              "aligator-test-py-constrained-dynamics"
            ]
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
