# Bibliothèques nécessaires aux binaires fournis avec STM32CubeIDE.
# Partagé entre la dérivation (LD_LIBRARY_PATH / rpath) et l'environnement FHS.
pkgs:
with pkgs;
[
  # Base
  gcc
  gdb
  glib
  gtk3
  gdk-pixbuf
  pango
  cairo
  atk
  zlib
  freetype
  fontconfig
  dbus
  dbus-glib

  # X11 / Wayland
  libx11
  libxrender
  libxtst
  libxi
  libxext
  libxdamage
  libXfixes
  libxcb
  libxau
  libxdmcp
  libxcb-image
  libxcb-render-util
  libxcb-wm
  libxcb-keysyms
  libxkbcommon
  wayland

  # OpenGL
  libGL
  libGLU
  mesa

  # Sondes de debug USB
  libusb1
  hidapi

  # GDB et outils ST
  ncurses5
  stdenv.cc.cc.lib
  expat
  python3
  openssl

  # Divers (JRE, CubeProgrammer)
  alsa-lib
  at-spi2-atk
  at-spi2-core
  cups
  udev
  nspr
  nss
  pcsclite
  xercesc
]
