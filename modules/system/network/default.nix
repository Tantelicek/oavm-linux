{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.system.network;
in {
  options = {
    system.network = {
      enable = lib.mkEnableOption "Nastavení sítě";
    };
  };

  config = lib.mkIf cfg.enable {
    networking.hostName = "oavm-linux"; # Jméno na síti (hostname)
    #networking.wireless.enable = true; # Bezdratové připojení (wpa_supplicant)
    #networking.wireless.userControlled.enable = true;

    # Síťová proxy (POZNÁMKA: zeptat se, zda bude nutná)
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Povolení networkingu
    networking.networkmanager.enable = true;

    # Povolení bluetooth
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Experimental = true;
          FastConnectable = true;
        };
        Policy = {
          AutoEnable = true;
        };
      };
    };

    # Povolování servisů (např OpenSSH daemon)
    # services.openssh.enable = true;

    # Práce s firewallem
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;
  };
}
