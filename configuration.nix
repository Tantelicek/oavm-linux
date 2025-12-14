# Základní konfigurace OAVM-Linux
{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Kernel (nejnovější stable)
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "oavm-linux"; # Jméno na síti (hostname)
  #networking.wireless.enable = true; # Bezdratové připojení (wpa_supplicant)

  # Síťová proxy (POZNÁMKA: zeptat se, zda bude nutná)
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Povolení networkingu
  networking.networkmanager.enable = true;

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

  # Povoluje KDE Plasmu jako desktop a SDDM jako login/desktop manager
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

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
    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Povolení touchpadu na X11 (povolenoo defaultně ve většině desktopManager).
  # services.xserver.libinput.enable = true;

  # VirtualBox additions - potřebné pro virtualizaci
  virtualisation.virtualbox.guest.enable = true;
  virtualisation.virtualbox.guest.dragAndDrop = true;

  # Uživatelský účet student (nastavení hesla přes passwd)
  users.users.student = {
    isNormalUser = true;
    description = "Student OAVM";
    extraGroups = ["networkmanager" "wheel"];
    initialPassword = "";
    packages = with pkgs; [
    ];
  };

  # Instalace firefoxu (nejspíše přesuneme do flaku)
  programs.firefox = {
    enable = true;
    preferences = {
      "widget.use-xdg-desktop-portal.file-picker" = 1;
    };
  };

  # Povolení nesvobodných (unfree) balíčků
  nixpkgs.config.allowUnfree = true;

  # Balíčky lze hledat na Webu, nebo přes následující příkaz
  # $ nix search wget

  # Povolení Flakes (jsou považovány za experimental funkci, my je ale potřebujeme)
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Blaíčky nainstalované na systémové úrovni (dávat přednost flake.nix)
  environment.systemPackages = with pkgs; [
    #Základní systémové
    git
    vim
    wget
    mc
    htop
    inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.fastfetch

    #VScode
    vscode-fhs

    #NixOS nástroje
    alejandra
    nixpkgs-fmt
    nixd

    #TEMPORARY
    discord

    #Sítě
    wireshark
    tshark
    filius
    nmap
    zenmap
    netcat
    nikto
    burpsuite
    inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.sqlmap
    inputs.imunes.packages.${pkgs.stdenv.hostPlatform.system}.imunes-before-break

    #OBD
    kdePackages.kleopatra
    gnupg1

    #Grafika + video
    gimp-with-plugins
    inkscape-with-extensions
    kdePackages.kdenlive
    haruna
    vlc

    #OIS
    drawio

    #Programování
    scenebuilder
    netbeans
    python314
    sourcegit

    #Základní desktop programy
    inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.onlyoffice-desktopeditors
    microsoft-edge
    inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.teams-for-linux
    libreoffice-qt-fresh
    kdePackages.kcalc
    kdePackages.kate
  ];

  #Fonty
  fonts.packages = with pkgs; [
    dm-sans
  ];

  programs.dconf.enable = true;

  # systemd.services.home-manager-student.serviceConfig = { RemainAfterExit = "yes"; };
  
  # Konfigurace potřebná pro nixd
  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

  #Povolení wiresharku
  programs.wireshark.enable = true;
  programs.wireshark.dumpcap.enable = true;
  programs.wireshark.usbmon.enable = false;

  #Plymouth - boot animace (JEŠTĚ PROKONZULTOVAT + PŘIDAT OAVM LOGO)
  boot = {
    plymouth = {
      enable = true;
      theme = "deus_ex";
      themePackages = with pkgs; [
        # By default we would install all themes
        (adi1090x-plymouth-themes.override {
          selected_themes = ["deus_ex"];
        })
      ];
    };

    # Enable "Silent boot"
    consoleLogLevel = 3;
    initrd.verbose = false;
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "udev.log_priority=3"
      "rd.systemd.show_status=auto"
    ];
  };

  # Skrytí nabídky systemd-boot.
  # Možno zobrazit zmáčknutím jakékoliv klávesy
  lib.mkForce.boot.loader.timeout = 0;

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 7d --keep 3";
    flake = "/home/student/oavm-linux/oavm-linux"; # sets NH_OS_FLAKE variable for you
  };

  # Povolování servisů (např OpenSSH daemon)

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Práce s firewallem

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # SUID wrappers (netuším co to je)

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Konfigurace systémové verze NEMĚNIT, unstable package brát přes flakes

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
