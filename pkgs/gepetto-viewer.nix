{
  darwin,
  fetchFromGitHub,
  fontconfig,
  lib,
  jrl-cmakemodules,
  libsForQt5,
  makeWrapper,
  openscenegraph,
  osgqt,
  python3Packages,
  qgv,
  stdenv,
  runCommand,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "gepetto-viewer";
  version = "6.1.0";

  src = fetchFromGitHub {
    owner = "gepetto";
    repo = "gepetto-viewer";
    rev = "v${finalAttrs.version}";
    hash = "sha256-wEwGRTNx9t/bQE8APLFvldwMkx4R/2eoIolAxkJR2dw=";
  };

  outputs = [
    "out"
    "dev"
    "bin"
    "doc"
  ];

  buildInputs = [
    python3Packages.boost
    python3Packages.python-qt
    libsForQt5.qtbase
  ];

  nativeBuildInputs =
    jrl-cmakemodules.docsNativeBuildInputs
    ++ [
      libsForQt5.wrapQtAppsHook
      python3Packages.python
    ]
    ++ lib.optionals (stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isAarch64) [
      darwin.autoSignDarwinBinariesHook
    ];

  propagatedBuildInputs = [
    jrl-cmakemodules
    openscenegraph
    osgqt
    qgv
  ];

  # wrapQtAppsHook uses isMachO, which fails to detect binaries without this
  # ref. https://github.com/NixOS/nixpkgs/pull/138334
  preFixup = lib.optionalString stdenv.hostPlatform.isDarwin "export LC_ALL=C";

  postFixup = ''
    # CMake is not aware exports are in $dev
    substituteInPlace $dev/lib/cmake/gepetto-viewer/gepetto-viewerConfig.cmake --replace-fail \
      "$out/lib/cmake" \
      "$dev/lib/cmake"

    # wrapQtAppsHook does only wrap stuff in $out, we want $bin
    echo wrapping $bin/bin/gepetto-gui
    wrapQtApp $bin/bin/gepetto-gui
  '';

  # Fontconfig error: Cannot load default config file: No such file: (null)
  env.FONTCONFIG_FILE = "${fontconfig.out}/etc/fonts/fonts.conf";

  # Fontconfig error: No writable cache directories
  preBuild = "export XDG_CACHE_HOME=$(mktemp -d)";

  passthru.withPlugins =
    plugins:
    runCommand "gepetto-gui"
      {
        inherit (finalAttrs) version;
        pname = "gepetto-gui";
        meta = {
          # can't just "inherit (gepetto-viewer) meta;" because:
          # error: derivation '/nix/store/…-gepetto-gui.drv' does not have wanted outputs 'bin'
          inherit (finalAttrs.finalPackage.meta)
            description
            homepage
            license
            maintainers
            mainProgram
            platforms
            ;
        };
        nativeBuildInputs = [ makeWrapper ];
        propagatedBuildInputs = plugins;
      }
      ''
        makeWrapper ${lib.getExe finalAttrs.finalPackage} $out/bin/gepetto-gui \
          --set GEPETTO_GUI_PLUGIN_DIRS ${lib.makeLibraryPath plugins}
      '';

  cmakeFlags = jrl-cmakemodules.docsCmakeFlags ++ [
    (lib.cmakeBool "BUILD_PY_QCUSTOM_PLOT" (!stdenv.hostPlatform.isDarwin))
    (lib.cmakeBool "BUILD_PY_QGV" (!stdenv.hostPlatform.isDarwin))
    (lib.cmakeBool "BUILD_TESTING" finalAttrs.doCheck)
  ];

  doCheck = true;

  strictDeps = true;
  __structuredAttrs = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Graphical Interface for Pinocchio and HPP";
    homepage = "https://github.com/gepetto/gepetto-viewer";
    license = lib.licenses.lgpl3Only;
    maintainers = [ lib.maintainers.nim65s ];
    mainProgram = "gepetto-gui";
    platforms = lib.platforms.unix;
  };
})
