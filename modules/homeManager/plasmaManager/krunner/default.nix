{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.pm.krunner;
in {
  options = {
    pm.krunner = {
      enable = lib.mkEnableOption "Nastavení Krunneru";
    };
  };

  config = lib.mkIf cfg.enable {

    programs.plasma.krunner = {
      activateWhenTypingOnDesktop = true;
      historyBehavior = "enableAutoComplete";
      position = "center";
    };

  };
}