{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.system.stylix;
in {
  options = {
    system.stylix = {
      enable = lib.mkEnableOption "Povolení použití stylixu";
    };
  };

  imports = [inputs.stylix.nixosModules.stylix];
  config = lib.mkIf cfg.enable {
    stylix.enable = true;
    # Barvy
    stylix.base16Scheme = {
      scheme = "OAVM";
      slug = "oavm";
      author = "tantelicek";
      description = "Barvy OAVM podle Manuálu od Ghosty Digital s.r.o";
      polarity = "dark";
      base00 = "#161622";
      base01 = "#181884";
      base02 = "#191A2E";
      base03 = "#20FF00";
      base04 = "#2B2D4F";
      base05 = "#dee8ff";#text
      base06 = "#EFF2FA";
      base07 = "#FFFFFF";
      base08 = "#DA1B21";
      base09 = "#6C80B3";
      base0A = "#F4A4A6";
      base0B = "#EB5C60";
      base0C = "#E4252B";
      base0D = "#2B4E9D";
      base0E = "#E6373D";
      base0F = "#138f00";
    };
    # Wallpaper
    stylix.image = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/Tantelicek/oavm-linux/refs/heads/main/files/oavm-wallpaper.jpg";
      hash = "sha256-LwoV84tHulozw65mAQHJ5b/mB1A6SlRvkfpWO3ULuj8=";
    };
    # Boot animace (plymouth)
    stylix.targets.plymouth = {
      logoAnimated = false;
      logo = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/Tantelicek/oavm-linux/refs/heads/main/files/oavm-logo-white-1920.png";
        hash = "sha256-H4oPTZajGtV54M9sSExWrYGiK5xpGfTUqRMTV8YSG4U=";
      };
    };

    #Plymouth - boot animace
    boot = {
      plymouth = {
        enable = true;
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

    # Fonty
    stylix.fonts = {
      serif = {
        package = pkgs.dm-sans;
        name = "DeepMind Sans";
      };

      sansSerif = {
        package = pkgs.dm-sans;
        name = "DeepMind Sans";
      };

      monospace = {
        package = pkgs.nerd-fonts.dejavu-sans-mono;
        name = "DejaVu Sans Mono";
      };

      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
    };
  };
}
