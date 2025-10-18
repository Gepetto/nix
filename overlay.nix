{
  inputs,
}:
(
  final: prev:
  {
    inherit (inputs)
      # keep-sorted start
      src-odri-control-interface
      src-odri-masterboard-sdk
      # keep-sorted end
      ;
    # keep-sorted start block=yes
    gepetto-viewer = prev.gepetto-viewer.overrideAttrs {
      src = inputs.src-gepetto-viewer;
    };
    gepetto-viewer-corba = prev.gepetto-viewer-corba.overrideAttrs {
      postPatch = ''
        substituteInPlace CMakeLists.txt --replace-fail \
          "cmake_minimum_required(VERSION 3.10)" \
          "cmake_minimum_required(VERSION 3.22)"
      '';
    };
    # TODO remove once https://github.com/NixOS/nixpkgs/pull/422562 is available
    openscenegraph = prev.openscenegraph.override {
      colladaSupport = final.lib.meta.availableOn final.stdenv.hostPlatform final.collada-dom;
    };
    # keep-sorted end
    pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
      (
        python-final: python-prev:
        {
          inherit (inputs)
            # keep-sorted start
            src-agimus-controller
            # keep-sorted end
            ;
          aligator = python-prev.aligator.overrideAttrs (super: {
            nativeCheckInputs = (super.nativeBuildInputs or [ ]) ++ [ final.ctestCheckHook ];
            disabledTests =
              (super.disabledTests or [ ])
              ++ final.lib.optionals final.stdenv.hostPlatform.isDarwin [
                # SIGTRAP on GHA
                "aligator-test-py-mpc"
              ];
          });
          brax = python-prev.brax.overrideAttrs {
            # depends on mujoco
            # which is broken on darwin
            meta.broken = final.stdenv.hostPlatform.isDarwin;
          };
          colmpc = python-final.toPythonModule (
            final.colmpc.override {
              pythonSupport = true;
              python3Packages = python-final;
            }
          );
          tyro = python-prev.tyro.overrideAttrs (super: {
            nativeBuildInputs = (super.nativeBuildInputs or [ ]) ++ [ python-final.pythonRelaxDepsHook ];
            pythonRelaxDeps = true;
          });
        }
        // final.lib.filesystem.packagesFromDirectoryRecursive {
          inherit (python-final) callPackage;
          directory = ./py-pkgs;
        }
      )
    ];
    rosPackages = prev.rosPackages // {
      humble = prev.rosPackages.humble.overrideScope (
        humble-final: humble-prev:
        {
          inherit (inputs)
            # keep-sorted start
            src-agimus-controller
            src-agimus-msgs
            # keep-sorted end
            ;
          franka-description = humble-prev.franka-description.overrideAttrs {
            src = inputs.src-franka-description;
            # depends on pyside2 which is broken on darwin
            meta.broken = final.stdenv.hostPlatform.isDarwin;
          };
        }
        // final.lib.filesystem.packagesFromDirectoryRecursive {
          inherit (humble-final) callPackage;
          directory = ./humble-pkgs;
        }
      );
      jazzy = prev.rosPackages.jazzy.overrideScope (
        jazzy-final: _jazzy-prev:
        {
          inherit (inputs)
            # keep-sorted start
            src-agimus-controller
            src-agimus-msgs
            # keep-sorted end
            ;
        }
        // final.lib.filesystem.packagesFromDirectoryRecursive {
          inherit (jazzy-final) callPackage;
          directory = ./jazzy-pkgs;
        }
      );
    };
  }
  // prev.lib.filesystem.packagesFromDirectoryRecursive {
    inherit (final) callPackage;
    directory = ./pkgs;
  }
)
