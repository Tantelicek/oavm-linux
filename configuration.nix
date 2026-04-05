# Základní konfigurace OAVM-Linux
{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: let
in {
  imports = [
    ./modules/basics
    ./modules/network
    ./modules/stylix
    ./modules/info
    ./modules/flatpak
    ./modules/users
    ./modules/temporary
  ];

  system.basics.enable = true;
  system.network.enable = true;
  system.stylix.enable = true;
  system.info.enable = true;
  system.flatpak.enable = true;
  system.users.enable = true;

  # Povoluje KDE Plasmu jako desktop a SDDM jako login/desktop manager
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "student";

  security.pam.services.student.kwallet.enable = true;
  security.pam.services.student.kwallet.forceRun = true;
  security.pam.services.student.kwallet.package = pkgs.kdePackages.kwallet-pam;

  # Instalace firefoxu
  programs.firefox = {
    enable = true;
    preferences = {
      "widget.use-xdg-desktop-portal.file-picker" = 1;
    };
  };

  # Blaíčky nainstalované na systémové úrovni (dávat přednost flake.nix)
  environment.systemPackages = with pkgs; [
    #Základní systémové
    git
    vim
    wget
    mc
    htop
    zip
    unzip
    mission-center
    inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.fastfetch

    #VScode
    vscode-fhs

    #NixOS nástroje
    alejandra
    nixpkgs-fmt
    nixd

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
    inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.audacity
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
    libreoffice-qt-fresh
    kdePackages.kcalc
    kdePackages.kate
  ];

  #Fonty
  fonts.packages = with pkgs; [
    dm-sans
    nerd-fonts.arimo
    nerd-fonts.dejavu-sans-mono
  ];

  # Povolení appimage souborů
  programs.appimage.enable = true;
  programs.appimage.binfmt = true;

  # systemd.services.home-manager-student.serviceConfig = { RemainAfterExit = "yes"; };

  # Konfigurace potřebná pro nixd
  nix.nixPath = ["nixpkgs=${inputs.nixpkgs}"];

  #Povolení wiresharku
  programs.wireshark.enable = true;
  programs.wireshark.dumpcap.enable = true;
  programs.wireshark.usbmon.enable = false;

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 7d --keep 3";
    flake = "/home/student/oavm-linux/oavm-linux"; # sets NH_OS_FLAKE variable for you
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  system.stateVersion = "25.05"; # Did you read the comment?
}
