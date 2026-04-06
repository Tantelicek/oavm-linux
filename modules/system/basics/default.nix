{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.system.basics;
in {
  options = {
    system.basics = {
      enable = lib.mkEnableOption "Základní systémové součásti";
    };
  };

  config = lib.mkIf cfg.enable {
    # Bootloader
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Kernel (nejnovější stable)
    boot.kernelPackages = pkgs.linuxPackages_latest;

    # Časová zóna
    time.timeZone = "Europe/Prague";

    # Vlastnosti pro mezinárodní použizí nastavené na Česko
    i18n.defaultLocale = "cs_CZ.UTF-8";

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "cs_CZ.UTF-8";
      LC_IDENTIFICATION = "cs_CZ.UTF-8";
      LC_MEASUREMENT = "cs_CZ.UTF-8";
      LC_MONETARY = "cs_CZ.UTF-8";
      LC_NAME = "cs_CZ.UTF-8";
      LC_NUMERIC = "cs_CZ.UTF-8";
      LC_PAPER = "cs_CZ.UTF-8";
      LC_TELEPHONE = "cs_CZ.UTF-8";
      LC_TIME = "cs_CZ.UTF-8";
    };

    # Povolení X11 (s Wayland kompozitorem není nutné, necháváme pro kompatibilitu)
    services.xserver.enable = true;

    # Klávesová mapa v X11
    services.xserver.xkb = {
      layout = "cz";
      variant = "";
    };

    # Klávesová mapa v terminálu
    console.keyMap = "cz-lat2";

    # CUPS - ovladač tiskáren
    services.printing.enable = true;

    # Povoluje Pipewire - moderní ovladač zvuku na linuxu
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # JACK - povolit při použití specifických programů
      #jack.enable = true;

      #Nejsem si jistý co je tohle - nejspíš nějaký manažer zdrojů pro Pipewire?
      #media-session.enable = true;
    };

    # Povolení touchpadu na X11 (povolenoo defaultně ve většině desktopManager).
    # services.xserver.libinput.enable = true;

    # Povolení nesvobodných (unfree) balíčků
    nixpkgs.config.allowUnfree = true;

    # Balíčky lze hledat na Webu, nebo přes následující příkaz
    # $ nix search wget

    # Povolení Flakes (jsou považovány za experimental funkci, my je ale potřebujeme)
    nix.settings.experimental-features = ["nix-command" "flakes"];

    programs.dconf.enable = true;

    # Enable OpenGL
    hardware.graphics = {
      enable = true;
    };

    # Konfigurace systémové verze NEMĚNIT, unstable package brát přes flakes
    
  };
}
