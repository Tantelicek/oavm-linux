#Nix-flatpak pro deklarativní správu flatpaků, zatím sem dávám i samotné instalace, ty bude možná vhodnější dát jinam.
{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.system.flatpak;
in {
  options = {
    system.flatpak = {
      enable = lib.mkEnableOption "Povolení flatpaků";
    };
  };

  imports = [inputs.nix-flatpak.nixosModules.nix-flatpak];
  config = lib.mkIf cfg.enable {
    services.flatpak.enable = true;

    xdg.portal = {
      enable = true;
      config = {
        common = {
          default = [
            "gtk"
          ];
        };
      };
      extraPortals = with pkgs; [
        xdg-desktop-portal-wlr
        kdePackages.xdg-desktop-portal-kde
        xdg-desktop-portal-gtk
      ];
    };

    services.flatpak.update.auto.enable = false;
    services.flatpak.uninstallUnmanaged = false;

    services.flatpak.packages = [
      "io.github.shonebinu.Brief"
    ];
  };
}
