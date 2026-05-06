{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cyclonedds-python_10,
  numpy,
  opencv-python,
}:

buildPythonPackage (_finalAttrs: {
  pname = "unitree-sdk2-python";
  version = "0-unstable-2026-04-30";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "unitreerobotics";
    repo = "unitree_sdk2_python";
    rev = "d9467c5fbe5428442048d4ebd2dec4b8f719a7c8";
    hash = "sha256-olsdI9xvFUGhnXQzxVvyK2yJV1+j+ILYqI0uT3QvI18=";
  };

  # workaround ImportError: cannot import name 'b2' from partially initialized module 'unitree_sdk2py'
  # ref. https://github.com/unitreerobotics/unitree_sdk2_python/pull/145
  postPatch = ''
    substituteInPlace unitree_sdk2py/__init__.py --replace-fail ", b2" ""
  '';

  build-system = [ setuptools ];

  dependencies = [
    cyclonedds-python_10
    numpy
    opencv-python
  ];

  pythonImportsCheck = [ "unitree_sdk2py" ];

  meta = {
    description = "Python interface for unitree sdk2";
    homepage = "https://github.com/unitreerobotics/unitree_sdk2_python";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nim65s ];
  };
})
