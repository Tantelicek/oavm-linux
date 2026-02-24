{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.system.info;
in {
  options = {
    system.info = {
      enable = lib.mkEnableOption "Povolení importu vlastních systémových infromací";
    };
  };
  config = lib.mkIf cfg.enable {
    # Nastavení vlastních informací o systému
    environment.etc."xdg/kcm-about-distrorc".text = let
      customLogo = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/Tantelicek/oavm-linux/refs/heads/main/files/VERT_smiley.ico";
        hash = "sha256-agXmWlbGD6GHupjDj8VSc0SsSd4Y7NAeo3Oe+NOCyFo=";
      };
    in ''
      [General]
      LogoPath=${customLogo}

      Name=OAVM Linux | Od Dominika Paly a Jana Houdka

      Website=https://www.oavm.cz
    '';

    # DŮLEŽITÉ: Změna názvu i v /etc/os-release (pro ostatní aplikace mimo KDE)
    environment.etc."os-release".text = ''
      NAME="OAVM Linux"
      ID=nixos
      VERSION="1.0"
      PRETTY_NAME="OAVM Linux | Od Dominika Paly a Jana Houdka
      HOME_URL="https://www.oavm.cz"
      SUPPORT_URL="https://github.com/Tantelicek/oavm-linux"
    '';
  };
}
