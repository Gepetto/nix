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

        # https://github.com/tensorflow/tensorflow/issues/102890
        tensorflow-bin = null;
        # https://github.com/NixOS/nixpkgs/pull/556423
        etils = python-prev.etils.overrideAttrs (super: {
          # need tensorflow
          disabledTests = super.disabledTests ++ [
            "test_use_backend"
          ];
          disabledTestPaths = super.disabledTestPaths ++ [
            "etils/ecolab/array_as_img_test.py"
            "etils/enp/array_spec_test.py"
            "etils/enp/array_types/dtypes_test.py"
            "etils/enp/checking_test.py"
            "etils/enp/compat_test.py"
            "etils/enp/geo_utils_test.py"
            "etils/enp/interp_utils_test.py"
            "etils/enp/linalg_test.py"
            "etils/enp/numpy_utils_test.py"
            "etils/etree/tree_utils_test.py"
          ];
        });
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

    lyrical = prev.rosPackages.lyrical.overrideScope (
      lyrical-final: _lyrical-prev:
      final.lib.filesystem.packagesFromDirectoryRecursive {
        inherit (lyrical-final) callPackage;
        directory = ./ros-pkgs/lyrical;
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
