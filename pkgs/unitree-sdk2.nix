{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,

  eigen,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "unitree-sdk2";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "unitreerobotics";
    repo = "unitree_sdk2";
    tag = finalAttrs.version;
    hash = "sha256-a+O3jQDJFq/v0zhpGJVuwjgWAZWkIqiNfKt/L4IOSco=";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    eigen
  ];

  meta = {
    description = "Unitree robot sdk version 2. https://support.unitree.com/home/zh/developer";
    homepage = "https://github.com/unitreerobotics/unitree_sdk2";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ nim65s ];
    mainProgram = "unitree-sdk2";
    platforms = lib.platforms.all;
  };
})
