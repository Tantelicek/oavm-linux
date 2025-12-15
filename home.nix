{
  pkgs,
  config,
  fetchurl,
  lib,
  ...
}: let
  # 1. Definice wallpaperu
  oavmwallpaper = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/Tantelicek/oavm-linux/refs/heads/main/files/oavm-wallpaper.jpg";
    hash = "sha256-LwoV84tHulozw65mAQHJ5b/mB1A6SlRvkfpWO3ULuj8=";
  };

  # 2. Stažení původní ikony (ICO)
  rawIcon = pkgs.fetchurl {
    name = "raw_smiley.ico";
    url = "https://raw.githubusercontent.com/Tantelicek/oavm-linux/main/files/VERT_smiley.ico";
    hash = "sha256-agXmWlbGD6GHupjDj8VSc0SsSd4Y7NAeo3Oe+NOCyFo=";
  };

  # 3. KROK NAVÍC: Automatická konverze ICO -> PNG
  # Toto zajistí, že ikona bude mít správný formát, kterému KDE rozumí.
  # Používáme '[0]', abychom vzali první vrstvu ikony (pro jistotu).
  finalPngIcon = pkgs.runCommand "logo.png" {
    nativeBuildInputs = [ pkgs.imagemagick ];
  } ''
    convert "${rawIcon}[0]" -background none -flatten $out
  '';

  fetchjson = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/Tantelicek/oavm-linux/refs/heads/main/dotfiles/config.jsonc";
    hash = "sha256-1TryXidtdAcQtnaVD1iblcm2DzO/sFxLA2s+m/pg/j0=";
  };

  fetchlogo = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/Tantelicek/oavm-linux/refs/heads/main/dotfiles/logo.txt";
    hash = "sha256-DSRWa4KMjDl3gG0DwErzMgMiC1Ez2OKFig3knqTHMO4=";
  };
in {
  home.stateVersion = "25.11";

  home.enableNixpkgsReleaseCheck = false;

  home.file."wallpaper.jpg" = {
    source = oavmwallpaper;
    onChange = "cp --remove-destination $(readlink wallpaper.jpg) wallpaper.jpg";
  };

  # Uložíme už hotové PNG do domovské složky (pro jistotu, kdyby bylo potřeba jinde)
  home.file."logo.png" = {
    source = finalPngIcon;
  };

  home.file."config.jsonc" = {
    source = fetchjson;
    target = "/.config/fastfetch/config.jsonc";
  };

  home.file."logo.txt" = {
    source = fetchlogo;
    target = "/.config/fastfetch/logo.txt";
  };

  programs.bash = {
    enable = true;
    initExtra = "fastfetch";
  };

  programs.konsole = {
    enable = true;
    defaultProfile = "student";
    profiles.student = {
      # command = "fastfetch && bash";
      font = {
        name = "DejaVu Sans Mono";
        size = 12;
       };
    };
  };

  programs.plasma = {
    enable = true;
    overrideConfig = true;

    workspace = {
      clickItemTo = "select";
      lookAndFeel = "org.kde.breezedark.desktop";
      cursor = {
        theme = "breeze_cursors";
        size = 24;
      };
      wallpaper = "/home/student/wallpaper.jpg";
      wallpaperFillMode = "pad";
    };

    hotkeys.commands."launch-konsole" = {
      name = "Launch Konsole";
      key = "Meta+Alt+K";
      command = "konsole";
    };

    fonts = {
      general = {
        family = "DeepMind Sans";
        pointSize = 12;
      };
      fixedWidth = {
        family = "DeepMind Sans";
        pointSize = 10;
      };
      menu = {
        family = "DeepMind Sans";
        pointSize = 10;
      };
      small = {
        family = "DeepMind Sans";
        pointSize = 8;
      };
      toolbar = {
        family = "DeepMind Sans";
        pointSize = 10;
      };
      windowTitle = {
        family = "DeepMind Sans";
        pointSize = 10;
      };
    };

    panels = [
      {
        alignment = "center";
        location = "bottom";
        floating = true;
        hiding = "dodgewindows";
        lengthMode = "fit";
        opacity = "adaptive";
        widgets = [
          {
            kickoff = {
              sortAlphabetically = true;
              # ZDE JE ZMĚNA: Odkazujeme přímo na vygenerované PNG v Nix Store.
              # To je nejspolehlivější metoda.
              icon = "${finalPngIcon}";
            };
          }
          {
            iconTasks = {
              launchers = [
                "applications:firefox.desktop"
                "applications:org.kde.dolphin.desktop"
                "applications:org.kde.konsole.desktop"
                "applications:onlyoffice-desktopeditors.desktop"
                "applications:code.desktop"
              ];

              appearance = {
                showTooltips = true;
                iconSpacing = "medium";
                indicateAudioStreams = true;
              };
              behavior = {
                grouping.clickAction = "cycle";
                middleClickAction = "newInstance";
                newTasksAppearOn = "right";
              };
            };
          }
          "org.kde.plasma.marginsseparator"
          {
            systemTray = {
              icons = {
                spacing = "medium";
              };
              items = {
                shown = [
                  "org.kde.plasma.volume"
                  "org.kde.plasma.bluetooth"
                ];
                hidden = [
                  "org.kde.plasma.battery"
                  "org.kde.plasma.networkmanagement"
                ];
              };
            };
          }
          {
            digitalClock = {
              date = {
                enable = true;
                format = "shortDate";
                position = "belowTime";
              };
              calendar = {
                firstDayOfWeek = "monday";
              };
              time = {
                format = "default";
                showSeconds = "always";
              };
              font.family = "DeepMind Sans";
            };
          }
        ];
      }
    ];

    window-rules = [
    ];

    powerdevil = {
      general.pausePlayersOnSuspend = true;
      AC = {
        powerButtonAction = "shutDown";
        autoSuspend = {
          idleTimeout = 1000;
        };
        turnOffDisplay = {
          idleTimeout = 2700;
          idleTimeoutWhenLocked = "immediately";
        };
        dimDisplay.enable = false;
        dimKeyboard.enable = false;
        keyboardBrightness = 100;
        powerProfile = "performance";
      };
      battery = {
        powerButtonAction = "sleep";
        whenSleepingEnter = "standbyThenHibernate";
      };
      lowBattery = {
        whenLaptopLidClosed = "sleep";
      };
    };

    kwin = {
      edgeBarrier = 0;
      cornerBarrier = false;
    };

    kscreenlocker = {
      lockOnResume = true;
      timeout = 10;
    };

    shortcuts = {
      ksmserver = {
        "Lock Session" = [
          "Screensaver"
          "Meta+Ctrl+Alt+L"
        ];
      };
      kwin = {
        "Expose" = "Meta+,";
        "Switch Window Down" = "Meta+J";
        "Switch Window Left" = "Meta+H";
        "Switch Window Right" = "Meta+L";
        "Switch Window Up" = "Meta+K";
      };
    };

    configFile = {
      baloofilerc."Basic Settings"."Indexing-Enabled" = false;
      kwinrc."org.kde.kdecoration2".ButtonsOnLeft = "SF";
      kwinrc.Desktops.Number = {
        value = 8;
        immutable = true;
      };
      kscreenlockerrc = {
        "Greeter" = {
          WallpaperPlugin = "org.kde.potd";
        };
        "Greeter/Wallpaper/org.kde.potd/General" = {
          Provider = "bing";
        };
      };
    };
  };


}
