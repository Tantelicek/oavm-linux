{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.hm.desktopEntries;
in {
  options = {
    hm.desktopEntries = {
      enable = lib.mkEnableOption "Nastavení možností v menu nabídky (start menu)";
    };
  };

  config = lib.mkIf cfg.enable {
    
    xdg.desktopEntries = {

#       obecne = {
#   name = "Obecne";
#   icon = "start-here-kde-plasma-symbolic";
#   type = "Directory";
# };

      kdenlive = {
      name = "Kdenlive 🌐";
      genericName = "Editor videa";
      exec = ''sh -c "nix run github:NixOS/nixpkgs/nixos-unstable#kdePackages.kdenlive"'';
      terminal = false;
      icon = "kdenlive";
      comment = "Open-source editor videa (online instalace)";
      type = "Application";
      };

      firefox = {
  name = "Firefox";
  genericName = "Webový prohlížeč";
  exec = ''firefox --name firefox %U'';
  terminal = false;
  icon = "firefox";
  mimeType = [
    "text/html"
    "text/xml"
    "application/xhtml+xml"
    "application/vnd.mozilla.xul+xml"
    "x-scheme-handler/http"
    "x-scheme-handler/https"
  ];
  comment = "Webový prohlížeč vyvíjený organizací Mozzila";
  type = "Application";
  categories = [ "Network" "WebBrowser" ];
  startupNotify = true;
  actions = {
    new-private-window = {
      name = "New Private Window";
      exec = ''firefox --private-window %U'';
    };
    new-window = {
      name = "New Window";
      exec = ''firefox --new-window %U'';
    };
    profile-manager-window = {
      name = "Profile Manager";
      exec = ''firefox --ProfileManager'';
    };
  };
};

imunes = {
  name = "Imunes";
  genericName = "Simulátor sítí";
  exec = ''imunes %F'';
  terminal = false;
  icon = pkgs.fetchurl {
    url = "https://imunes.net/images/imunes_logo.png";
    hash = "sha256-IoAlhvJf8YgE63mOOldIJmRzQlsOB/tixv1IrpgHaD8=";
  };
  comment = "Děkujeme Milánské Univerzitě :D";
  type = "Application";
  noDisplay = false;
  prefersNonDefaultGPU = false;
  startupNotify = true;
};

filius = {
  name = "Filius";
  genericName = "Simulátor sítí";
  exec = ''filius %f'';
  terminal = false;
  icon = pkgs.fetchurl {
    url = "https://imgproxy.flathub.org/insecure/dpr:1/f:avif/q:100/rs:fit:128:128/aHR0cHM6Ly9kbC5mbGF0aHViLm9yZy9tZWRpYS9kZS9sZXJuc29mdHdhcmVfZmlsaXVzL0ZpbGl1cy9iMDIyOTFjNWNiZDUxOWJhNzE2Y2FkYjUzNGVkNGYwYS9pY29ucy8xMjh4MTI4L2RlLmxlcm5zb2Z0d2FyZV9maWxpdXMuRmlsaXVzLnBuZw";
    hash = "sha256-Pz6uCU/ePZWoe0FwP/hO3bgwnvIq0o2NW+vI26OF/NY=";
  };
  comment = "Povědomý německý simulátor sítí";
  type = "Application";
  categories = [ "Education" ];
  mimeType = [ "application/filius-project" ];
  noDisplay = false;
  prefersNonDefaultGPU = false;
  startupNotify = false;
};


oavm = {
  name = "OAVM";
  genericName = "Web školy";
  exec = ''sh -c "xdg-open 'https://www.oavm.cz/'"'';
  terminal = false;
  icon = pkgs.fetchurl {
    name = "raw_smiley.ico";
    url = "https://raw.githubusercontent.com/Tantelicek/oavm-linux/main/files/VERT_smiley.ico";
    hash = "sha256-agXmWlbGD6GHupjDj8VSc0SsSd4Y7NAeo3Oe+NOCyFo=";
  };
  comment = "Oficiální webové stránky OAVM";
  type = "Application";
  noDisplay = false;
  prefersNonDefaultGPU = false;
  startupNotify = true;
};

    };

    
  };
}
