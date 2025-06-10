{
  lib,
  python,
  fetchFromGitHub,
  setuptools,
  wheel,
  opencv-python,
  cyclonedds-python,
  numpy
}:

let
	pythonOverriden = python.override {
		self = python;
		packageOverrides = lib.composeManyExtensions [ (self: super: {
			cyclonedds-python = super.cyclonedds-python.overridePythonAttrs (oldattrs: rec {
				version = "0.10.2";
				src = fetchFromGitHub {
					inherit (oldattrs.src) owner repo;
					tag = "v${version}";
					hash = "";
				};
			});
		}) ];
	};
in
pythonOverriden.pkgs.buildPythonPackage {
  pname = "unitree-sdk2-python";
  version = "0-unstable-2025-03-05";
  pyproject = true;

  src = fetchFromGitHub {
  	owner = "unitreerobotics";
	repo = "unitree_sdk2_python";
	rev = "986f39d54182badc1aa3a0c282bcd898fba4ef20";
	hash = "sha256-0n5v9B92Sr2MnGSH91ucXHZWOAzypER0hNZAAspLVvM=";
  };

  pythonRelaxDeps = [
    cyclonedds-python # TODO
  ];

  build-system = [
    setuptools
    wheel
  ];

  buildInputs = with pythonOverriden.pkgs; [
    cyclonedds-python
    opencv-python
    numpy
  ];

  pythonImportsCheck = [
    "unitree_sdk2py"
  ];

  meta = {
    description = "Python interface for unitree sdk2";
    homepage = "https://github.com/unitreerobotics/unitree_sdk2_python";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ gwennlbh ];
    platforms = lib.platforms.unix;
  };
}
