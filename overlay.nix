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
    crocoddyl = prev.crocoddyl.overrideAttrs (super: {
      # ref. https://github.com/loco-3d/crocoddyl/pull/1369
      patches = (super.patches or [ ]) ++ [
        (final.fetchpatch {
          url = "https://github.com/loco-3d/crocoddyl/commit/ace3245a1ddaa27824a2678dd82573fef7716f44.patch";
          hash = "sha256-PfHWBMGLZRBUitml/64eESRSXQrDQMDGHTUOjEmG+lw=";
        })
      ];
    });
    gepetto-viewer = prev.gepetto-viewer.overrideAttrs {
      src = inputs.src-gepetto-viewer;
    };
    jrl-cmakemodules = prev.jrl-cmakemodules.overrideAttrs {
      # ref. https://github.com/jrl-umi3218/jrl-cmakemodules/pull/783
      patches = [
        (final.fetchpatch {
          name = "fix-permissions.patch";
          url = "https://github.com/jrl-umi3218/jrl-cmakemodules/commit/defed70c8a7c5e4bd5b26006bef26e3fb22c3b26.patch";
          hash = "sha256-muO6DwQhNPCv6DPmnHnEHjsh/FSj0ljgNCb+ZowLRaY=";
        })
      ];
      postPatch = ''
        substituteInPlace CMakeLists.txt --replace-fail "./flake." "#./flake."
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
