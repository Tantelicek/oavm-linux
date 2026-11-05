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
    services.xserver.videoDrivers = [
      "nvidia"
      "modesetting"
    ];

    hardware.nvidia = {
      # Modesetting is required.
      modesetting.enable = true;

      prime = {
        offload.enable = true;

        nvidiaBusId = "PCI:1@0:0:0";
        amdgpuBusId = "PCI:5@0:0:0";
      };

      # Use the NVidia open source kernel module (not to be confused with the
      # independent third-party "nouveau" open source driver).
      # Support is limited to the Turing and later architectures. Full list of
      # supported GPUs is at:
      # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
      # Only available from driver 515.43.04+
      open = true;

      # Enable the Nvidia settings menu,
      # accessible via `nvidia-settings`.
      nvidiaSettings = true;

      # Optionally, you may need to select the appropriate driver version for your specific GPU.
      package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
        version = "610.57.04";
        sha256_64bit = "sha256-suk1xmuDuwDAyFe8jg7g/VLekoa0DJzB7sKafOfrEW0=";
        sha256_aarch64 = "";
        openSha256 = "sha256-rQHOOOY4KL92Ww3KDwh+j4eGU7oNAH8LutZC5wmFnPo=";
        settingsSha256 = "sha256-ZEMo8I8Zc2Tq6RVDNYpAH+f094dUaZiBqO+5f6lIjRI=";
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

  
      services.netbird.enable = true;


    environment.systemPackages = with pkgs; [
      #wpa_supplicant_gui
      mediawriter
      discord
      ventoy-full-qt
      inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.netbird-ui
      kdePackages.kcolorchooser
      localsend
      gnome-disk-utility
      obsidian
      qbittorrent
      moonlight-qt
    ];

    nixpkgs.config.permittedInsecurePackages = [
      "ventoy-qt5-1.1.10"
    ];

    programs.steam = {
      enable = true; # Master switch, already covered in installation
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true;
      extraCompatPackages = with pkgs; [inputs.nixpkgs-unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.proton-ge-bin]; # Open ports for Source Dedicated Server hosting
      # Other general flags if available can be set here.
    };

    # # VirtualBox additions - potřebné pro virtualizaci
    # virtualisation.virtualbox.guest.enable = true;
    # virtualisation.virtualbox.guest.dragAndDrop = true;

    users.users.student.extraGroups = ["wheel"];
  };
}
