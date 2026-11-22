let
  fr = "fr_FR.UTF-8";
in
{
  time.timeZone = "Europe/Paris";

  # Interface en anglais, formats (dates, unités, monnaie…) en français
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = fr;
    LC_IDENTIFICATION = fr;
    LC_MEASUREMENT = fr;
    LC_MONETARY = fr;
    LC_NAME = fr;
    LC_NUMERIC = fr;
    LC_PAPER = fr;
    LC_TELEPHONE = fr;
    LC_TIME = fr;
  };

  # Clavier AZERTY, défini une seule fois pour X11/Wayland et la console
  services.xserver.xkb = {
    layout = "fr";
    variant = "azerty";
  };
  console.useXkbConfig = true;
}
