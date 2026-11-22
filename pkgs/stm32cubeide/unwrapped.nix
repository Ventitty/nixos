{
  lib,
  stdenv,
  requireFile,
  autoPatchelfHook,
  makeWrapper,
  pkgsCross,
  pkgs,
}:

let
  version = "1.19.0";
  buildNumber = "25607";
  tarballName = "st-stm32cubeide_${version}_${buildNumber}_20250703_0907_amd64.tar.gz";

  runtimeDeps = import ./runtime-deps.nix pkgs;
  libPath = lib.makeLibraryPath runtimeDeps;

  # Remplace le arm-none-eabi-gdb fourni par ST, qui dépend de libncurses5.
  # https://community.st.com/t5/stm32cubeide-mcus/could-not-determine-gdb-version/td-p/734073
  arm-gdb = pkgsCross.arm-embedded.buildPackages.gdb;
in
stdenv.mkDerivation {
  pname = "stm32cubeide-unwrapped";
  inherit version;

  # Logiciel propriétaire : l'archive doit être ajoutée au store à la main.
  src = requireFile {
    name = tarballName;
    sha256 = "18fc11e62fc575649956ed9fb477ff4541f25bd2d851d185cafebc9e7f9a9f64";
    message = ''
      L'archive de STM32CubeIDE ${version} n'est pas dans le store Nix.

      1. Télécharger l'installeur Linux sur
         https://www.st.com/en/development-tools/stm32cubeide.html
         (en.st-stm32cubeide_${version}_${buildNumber}_20250703_0907_amd64.sh.zip)
      2. Le dézipper pour récupérer ${tarballName}
      3. L'ajouter au store :

         nix-store --add-fixed sha256 ${tarballName}
    '';
  };

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [
    autoPatchelfHook
    makeWrapper
  ];
  buildInputs = runtimeDeps;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/opt/stm32cubeide $out/bin
    tar -xzf $src -C $out/opt/stm32cubeide

    makeWrapper $out/opt/stm32cubeide/stm32cubeide $out/bin/stm32cubeide \
      --prefix LD_LIBRARY_PATH : "${libPath}" \
      --set GDK_BACKEND x11 \
      --set GTK_THEME Adwaita

    if [ -f $out/opt/stm32cubeide/headless-build.sh ]; then
      makeWrapper $out/opt/stm32cubeide/headless-build.sh $out/bin/stm32cubeide-headless \
        --prefix LD_LIBRARY_PATH : "${libPath}"
    fi

    mkdir -p $out/share/applications
    cat > $out/share/applications/stm32cubeide.desktop << EOF
    [Desktop Entry]
    Name=STM32CubeIDE ${version}
    Comment=Integrated Development Environment for STM32
    GenericName=STM32 IDE
    Exec=$out/bin/stm32cubeide %F
    Icon=$out/opt/stm32cubeide/icon.xpm
    Path=$out/opt/stm32cubeide
    Terminal=false
    StartupNotify=true
    Type=Application
    Categories=Development;IDE;Electronics;
    MimeType=application/x-stm32cubeide;
    EOF

    if [ -f $out/opt/stm32cubeide/icon.xpm ]; then
      install -Dm644 $out/opt/stm32cubeide/icon.xpm $out/share/pixmaps/stm32cubeide.xpm
    fi

    runHook postInstall
  '';

  # Bibliothèques fournies avec l'IDE ou optionnelles
  autoPatchelfIgnoreMissingDeps = [
    "libjli.so"
    "libhsmp11.so"
    "libPreparation.so.1"
    # Qt6 embarqué (CubeProgrammer)
    "libQt6Core.so.6"
    "libQt6DBus.so.6"
    "libQt6Gui.so.6"
    "libQt6Network.so.6"
    "libQt6OpenGL.so.6"
    "libQt6Qml.so.6"
    "libQt6SerialPort.so.6"
    "libQt6Widgets.so.6"
    "libQt6XcbQpa.so.6"
    "libQt6Xml.so.6"
    "libQt6EglFSDeviceIntegration.so.6"
    "libQt6WaylandEglClientHwIntegration.so.6"
    "libQt6WaylandClient.so.6"
    # Qt4 embarqué (outils J-Link)
    "libQtCore.so.4"
    "libQtGui.so.4"
    # J-Link embarqué
    "libjlinkarm.so"
    "libjlinkarm.so.8"
    # Plugins FFmpeg optionnels du JRE
    "libavformat-ffmpeg.so.56"
    "libavcodec-ffmpeg.so.56"
  ]
  ++ lib.concatMap (v: [
    "libavformat.so.${v}"
    "libavcodec.so.${v}"
  ]) [ "54" "56" "57" "58" "59" "60" ]
  ++ [
    # nixpkgs fournit xerces 3.3, l'IDE demande 3.2
    "libxerces-c-3.2.so"
  ];

  postFixup = ''
    plugins=$out/opt/stm32cubeide/plugins
    findPlugin() {
      find $plugins -type d -name "$1" | head -1
    }

    # arm-none-eabi-gdb : utiliser celui de nixpkgs
    GNU_TOOLS_DIR=$(findPlugin "com.st.stm32cube.ide.mcu.externaltools.gnu-tools-for-stm32.*.linux64_*")
    if [ -n "$GNU_TOOLS_DIR" ] && [ -f "$GNU_TOOLS_DIR/tools/bin/arm-none-eabi-gdb" ]; then
      mv "$GNU_TOOLS_DIR/tools/bin/arm-none-eabi-gdb" "$GNU_TOOLS_DIR/tools/bin/arm-none-eabi-gdb.bak"
      ln -s ${arm-gdb}/bin/arm-none-eabi-gdb "$GNU_TOOLS_DIR/tools/bin/arm-none-eabi-gdb"
    fi

    # CubeProgrammer : retrouver ses bibliothèques embarquées
    CUBEPROG_DIR=$(findPlugin "com.st.stm32cube.ide.mcu.externaltools.cubeprogrammer.linux64_*")
    if [ -n "$CUBEPROG_DIR" ]; then
      patchelf --set-rpath "$CUBEPROG_DIR/tools/lib:${libPath}" \
        "$CUBEPROG_DIR/tools/bin/STM32_Programmer_CLI" || true
    fi

    # Outils J-Link
    JLINK_DIR=$(findPlugin "com.st.stm32cube.ide.mcu.externaltools.jlink.linux64_*")
    if [ -n "$JLINK_DIR" ]; then
      for bin in "$JLINK_DIR"/tools/bin/JLink*; do
        if [ -f "$bin" ] && [ -x "$bin" ]; then
          patchelf --set-rpath "$JLINK_DIR/tools/bin:${libPath}" "$bin" || true
        fi
      done
    fi

    # JRE embarqué
    JRE_DIR=$(findPlugin "com.st.stm32cube.ide.jre.linux64_*")
    if [ -n "$JRE_DIR" ] && [ -d "$JRE_DIR/jre" ]; then
      jreRpath="$JRE_DIR/jre/lib:$JRE_DIR/jre/lib/server:${libPath}"
      for f in "$JRE_DIR"/jre/bin/* "$JRE_DIR"/jre/lib/*.so "$JRE_DIR"/jre/lib/server/*.so; do
        if [ -f "$f" ]; then
          patchelf --set-rpath "$jreRpath" "$f" || true
        fi
      done
    fi
  '';

  meta = {
    description = "Integrated Development Environment for STM32 microcontrollers";
    homepage = "https://www.st.com/en/development-tools/stm32cubeide.html";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
