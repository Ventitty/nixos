{
  lib,
  stdenv,
  autoPatchelfHook,
  libusb1,
}:

stdenv.mkDerivation {
  pname = "stlink-server";
  version = "2.1.1-5";

  # Binaire extrait de l'installeur officiel ST (st-stlink-server.*.install.sh)
  src = ./stlink-server;
  dontUnpack = true;

  nativeBuildInputs = [ autoPatchelfHook ];
  buildInputs = [
    libusb1
    stdenv.cc.cc.lib
  ];

  installPhase = ''
    runHook preInstall
    install -Dm755 $src $out/bin/stlink-server
    runHook postInstall
  '';

  meta = {
    description = "ST-Link GDB server for STM32 microcontrollers";
    homepage = "https://www.st.com/en/development-tools/st-link-server.html";
    license = lib.licenses.unfree;
    platforms = [ "x86_64-linux" ];
    mainProgram = "stlink-server";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}
