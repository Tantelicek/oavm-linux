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
      base00 = "050508";
      base01 = "161727";
      base02 = "20212e";
      base03 = "292a33";
      base04 = "444444";
      base05 = "dcdeff";
      base06 = "eaf1ff";
      base07 = "FFFFFF";
      base08 = "E6373D";
      base09 = "e96949";
      base0A = "f0bf3a";
      base0B = "73f553";
      base0C = "3057B0";
      base0D = "2B4E9D";
      base0E = "461952";
      base0F = "DA1B21";
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
