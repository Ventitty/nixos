# Valeurs partagées entre les modules, lisibles partout via `config.my.*`.
{ lib, ... }:

{
  options.my.username = lib.mkOption {
    type = lib.types.str;
    default = "lyre";
    description = "Utilisateur principal de la machine.";
  };
}
