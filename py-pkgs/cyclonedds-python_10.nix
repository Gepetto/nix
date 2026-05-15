# TODO : nixpkgs has cyclonedds-python 11, we need to test that
{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  rich-click,
  cyclonedds,
  pythonOlder,
}:

buildPythonPackage (finalAttrs: {
  pname = "cyclonedds-python_10";
  version = "0.10.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "eclipse-cyclonedds";
    repo = "cyclonedds-python";
    tag = finalAttrs.version;
    hash = "sha256-EnvNWIYDviMPANanUqI7Uk8lQBjXcN9DVb9OZlAelrM=";
  };

  postPatch = lib.optionalString (!pythonOlder "3.13") ''
    substituteInPlace clayer/pysertype.c \
        --replace-fail "_Py_IsFinalizing()" "Py_IsFinalizing()"
  '';

  build-system = [ setuptools ];

  buildInputs = [ cyclonedds ];

  dependencies = [ rich-click ];

  pythonImportsCheck = [ "cyclonedds" ];

  env.CYCLONEDDS_HOME = "${cyclonedds.out}";

  meta = {
    description = "";
    homepage = "https://github.com/eclipse-cyclonedds/cyclonedds-python";
    license = lib.licenses.epl20;
    maintainers = with lib.maintainers; [ nim65s ];
  };
})
