{
  pkgs,
  config,
  fetchurl,
  lib,
  ...
}: let
  oavmwallpaper = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/Tantelicek/oavm-linux/refs/heads/main/files/oavm-wallpaper.jpg";
    hash = "sha256-LwoV84tHulozw65mAQHJ5b/mB1A6SlRvkfpWO3ULuj8=";
  };

  oavmsmiley = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/Tantelicek/oavm-linux/refs/heads/main/files/VERT_smiley.ico";
    hash = "sha256-agXmWlbGD6GHupjDj8VSc0SsSd4Y7NAeo3Oe+NOCyFo=";
  };
in {
  home.stateVersion = "25.11";

  home.file."wallpaper.jpg" = {
    source = oavmwallpaper;
    onChange = "cp --remove-destination $(readlink wallpaper.jpg) wallpaper.jpg";
    # ignorelinks = true;
    # recursive = true;
    # force = true;
  };
  
  home.file."smiley.ico" = {
    source = oavmsmiley;
    onChange = "cp --remove-destination $(readlink smiley.ico) smiley.png";
    # ignorelinks = true;
    # recursive = true;
    # force = true;
  };

  programs.plasma = {
    enable = true;
    overrideConfig = true;
    #
    # Some high-level settings
    #
    workspace = {
      clickItemTo = "select"; # If you liked the click-to-open default from plasma 5
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

    # Widgety na ploše
    # desktop.widgets = [
    #   {
    #     plasmusicToolbar = {
    #       position = {
    #         horizontal = 51;
    #         vertical = 100;
    #       };
    #       size = {
    #         width = 250;
    #         height = 250;
    #       };
    #     };
    #   }
    # ];

    panels = [
      # Windows-like panel at the bottom
      {
        alignment = "center";
        location = "bottom";
        floating = true;
        hiding = "dodgewindows";
        lengthMode = "fit";
        opacity = "adaptive";
        widgets = [
          # We can configure the widgets by adding the name and config
          # attributes. For example to add the the kickoff widget and set the
          # icon to "nix-snowflake-white" use the below configuration. This will
          # add the "icon" key to the "General" group for the widget in
          # ~/.config/plasma-org.kde.plasma.desktop-appletsrc.
          # {
          #   name = "org.kde.plasma.kickoff";
          #   config = {
          #     General = {
          #       icon = "nix-snowflake-white";
          #       alphaSort = true;
          #     };
          #   };
          # }
          # Or you can configure the widgets by adding the widget-specific options for it.
          # See modules/widgets for supported widgets and options for these widgets.
          # For example:
          {
            kickoff = {
              sortAlphabetically = true;
             icon = "/home/student/smiley.png";
            };
          }
          # Adding configuration to the widgets can also for example be used to
          # pin apps to the task-manager, which this example illustrates by
          # pinning dolphin and konsole to the task-manager by default with widget-specific options.
          {
            iconTasks = {
              launchers = [
                "applications:firefox.desktop"
                #"applications:microsoft-edge.desktop"
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
          # # Or you can do it manually, for example:
          # {
          #   name = "org.kde.plasma.icontasks";
          #   config = {
          #     General = {
          #       launchers = [
          #         "applications:org.kde.dolphin.desktop"
          #         "applications:org.kde.konsole.desktop"
          #       ];
          #     };
          #   };
          # }
          # If no configuration is needed, specifying only the name of the
          # widget will add them with the default configuration.
          "org.kde.plasma.marginsseparator"
          # If you need configuration for your widget, instead of specifying the
          # the keys and values directly using the config attribute as shown
          # above, plasma-manager also provides some higher-level interfaces for
          # configuring the widgets. See modules/widgets for supported widgets
          # and options for these widgets. The widgets below shows two examples
          # of usage, one where we add a digital clock, setting 12h time and
          # first day of the week to Sunday and another adding a systray with
          # some modifications in which entries to show.
          {
            systemTray = {
              icons = {
                spacing = "medium";
              };
              items = {
                # We explicitly show bluetooth and battery
                shown = [
                  "org.kde.plasma.volume"
                  "org.kde.plasma.bluetooth"
                ];
                # And explicitly hide networkmanagement and volume
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

          
            #DŮLEŽITÉ!!!, přidat button na minimize all tabs
          
        ];
      }
      # Application name, Global menu and Song information and playback controls at the top
      # {
      #   location = "top";
      #   height = 26;
      #   widgets = [
      #     {
      #       applicationTitleBar = {
      #         behavior = {
      #           activeTaskSource = "activeTask";
      #         };
      #         layout = {
      #           elements = ["windowTitle"];
      #           horizontalAlignment = "left";
      #           showDisabledElements = "deactivated";
      #           verticalAlignment = "center";
      #         };
      #         overrideForMaximized.enable = false;
      #         titleReplacements = [
      #           {
      #             type = "regexp";
      #             originalTitle = "^Brave Web Browser$";
      #             newTitle = "Brave";
      #           }
      #           {
      #             type = "regexp";
      #             originalTitle = ''\\bDolphin\\b'';
      #             newTitle = "File manager";
      #           }
      #         ];
      #         windowTitle = {
      #           font = {
      #             bold = false;
      #             fit = "fixedSize";
      #             size = 12;
      #           };
      #           hideEmptyTitle = true;
      #           margins = {
      #             bottom = 0;
      #             left = 10;
      #             right = 5;
      #             top = 0;
      #           };
      #           source = "appName";
      #         };
      #       };
      #     }
      #     "org.kde.plasma.appmenu"
      #     "org.kde.plasma.panelspacer"
      #     {
      #       plasmusicToolbar = {
      #         panelIcon = {
      #           albumCover = {
      #             useAsIcon = false;
      #             radius = 8;
      #           };
      #           icon = "view-media-track";
      #         };
      #         playbackSource = "auto";
      #         musicControls.showPlaybackControls = true;
      #         songText = {
      #           displayInSeparateLines = true;
      #           maximumWidth = 640;
      #           scrolling = {
      #             behavior = "alwaysScroll";
      #             speed = 3;
      #           };
      #         };
      #       };
      #     }
      #   ];
      # }
    ];

    window-rules = [
      # {
      #   description = "Dolphin";
      #   match = {
      #     window-class = {
      #       value = "dolphin";
      #       type = "substring";
      #     };
      #     window-types = ["normal"];
      #   };
      #   apply = {
      #     noborder = {
      #       value = true;
      #       apply = "force";
      #     };
      #     # `apply` defaults to "apply-initially"
      #     maximizehoriz = true;
      #     maximizevert = true;
      #   };
      # }
    ];

    powerdevil = {
      general.pausePlayersOnSuspend = true;
      AC = {
        powerButtonAction = "shutDown";
        autoSuspend = {
          #action = "nothing";
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
      edgeBarrier = 0; # Disables the edge-barriers introduced in plasma 6.1
      cornerBarrier = false;
    };

    kscreenlocker = {
      lockOnResume = true;
      timeout = 10;
    };

    #
    # Some mid-level settings:
    #
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

    #
    # Some low-level settings:
    #
    configFile = {
      baloofilerc."Basic Settings"."Indexing-Enabled" = false;
      kwinrc."org.kde.kdecoration2".ButtonsOnLeft = "SF";
      kwinrc.Desktops.Number = {
        value = 8;
        # Forces kde to not change this value (even through the settings app).
        immutable = true;
      };
      kscreenlockerrc = {
        Greeter.WallpaperPlugin = "org.kde.potd";
        # To use nested groups use / as a separator. In the below example,
        # Provider will be added to [Greeter][Wallpaper][org.kde.potd][General].
        "Greeter/Wallpaper/org.kde.potd/General".Provider = "bing";
      };
    };
  };
}
