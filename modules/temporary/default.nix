{
  lib,
  config,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.temporary;
in {
  options = {
    temporary = {
      enable = lib.mkEnableOption "Povolení temporary součásti, určené pro vývoj OAVM Linux  ";
    };
  };

  config = lib.mkIf cfg.enable {
    # Load nvidia driver for Xorg and Wayland
    services.xserver.videoDrivers = ["nvidia"];

    hardware.nvidia = {
      # Modesetting is required.
      modesetting.enable = true;

      # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
      # Enable this if you have graphical corruption issues or application crashes after waking
      # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
      # of just the bare essentials.
      powerManagement.enable = false;

      # Fine-grained power management. Turns off GPU when not in use.di
      # Experimental and only works on modern Nvidia GPUs (Turing or newer).
      powerManagement.finegrained = false;

      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures. Full list of
      # supported GPUs is at:
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
      # Only available from driver 515.43.04+
      open = false;

      # Enable the Nvidia settings menu,
      # accessible via `nvidia-settings`.
      nvidiaSettings = true;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
        version = "590.48.01";
        sha256_64bit = "sha256-ueL4BpN4FDHMh/TNKRCeEz3Oy1ClDWto1LO/LWlr1ok=";
        sha256_aarch64 = "";
        openSha256 = "";
        settingsSha256 = "sha256-NWsqUciPa4f1ZX6f0By3yScz3pqKJV1ei9GvOF8qIEE=";
        persistencedSha256 = "";
      };
    };

    # services.netbird.clients.wt0 = {
    #   # Automatically login to your Netbird network with a setup key
    #   # This is mostly useful for server computers.
    #   # For manual setup instructions, see the wiki page section below.
    #   login = {
    #     enable = true;

    #     # Path to a file containing the setup key for your peer
    #     # NOTE: if your setup key is reusable, make sure it is not copied to the Nix store.
    #     setupKeyFile = "/path/to/your/setup-key";
    #   };

    #   # Port used to listen to wireguard connections
    #   port = 51821;

    #   # Set this to true if you want the GUI client
    #   ui.enable = false;

    #   # This opens ports required for direct connection without a relay
    #   openFirewall = true;

    #   # This opens necessary firewall ports in the Netbird client's network interface
    #   openInternalFirewall = true;
    # };

    services.netbird.enable = true; # for netbird service & CLI

    environment.systemPackages = with pkgs; [
      #wpa_supplicant_gui
      mediawriter
      discord
      ventoy-full-qt
      inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.netbird-ui
    ];

    nixpkgs.config.permittedInsecurePackages = [
      "ventoy-qt5-1.1.10"
    ];

    # # VirtualBox additions - potřebné pro virtualizaci
    # virtualisation.virtualbox.guest.enable = true;
    # virtualisation.virtualbox.guest.dragAndDrop = true;

    users.users.student.extraGroups = ["wheel"];
  };
}
