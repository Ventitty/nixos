# STM32CubeIDE lancé dans un environnement FHS, pour une compatibilité maximale
# avec les binaires fournis par ST.
{
  buildFHSEnv,
  stm32cubeide-unwrapped,
}:

buildFHSEnv {
  name = "stm32cubeide";
  targetPkgs = pkgs: import ./runtime-deps.nix pkgs ++ [ stm32cubeide-unwrapped ];
  runScript = "${stm32cubeide-unwrapped}/bin/stm32cubeide";

  # Exposer le .desktop et l'icône pour que KDE trouve l'application
  extraInstallCommands = ''
    install -Dm644 ${stm32cubeide-unwrapped}/share/applications/stm32cubeide.desktop \
      $out/share/applications/stm32cubeide.desktop
    substituteInPlace $out/share/applications/stm32cubeide.desktop \
      --replace-fail "Exec=${stm32cubeide-unwrapped}/bin/stm32cubeide" "Exec=$out/bin/stm32cubeide"
    if [ -f ${stm32cubeide-unwrapped}/share/pixmaps/stm32cubeide.xpm ]; then
      install -Dm644 ${stm32cubeide-unwrapped}/share/pixmaps/stm32cubeide.xpm \
        $out/share/pixmaps/stm32cubeide.xpm
    fi
  '';

  inherit (stm32cubeide-unwrapped) meta;
}
