{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.pm;
in {
  options = {
    pm = {
      enable = lib.mkEnableOption "Nastavení možností v menu nabídky (start menu)";
    };
  };

  imports = [
    ./krunner
  ];

  config = lib.mkIf cfg.enable {

    pm.krunner.enable = true;

  };
}