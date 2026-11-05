{ config, inputs, lib, pkgs, ... }:

let
  sys = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {inherit inputs;};
    modules = [
      
      ({ config, pkgs, lib, modulesPath, ... }: {
        imports = [ 
          (modulesPath + "/installer/netboot/netboot-minimal.nix") 
          ];
      })

      ./../../configuration.nix

      inputs.home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.sharedModules = [inputs.plasma-manager.homeModules.plasma-manager];
          home-manager.users.student = import ./../../home.nix;
        }

    ];
  };

  build = sys.config.system.build;
in {
  services.pixiecore = {
    enable = true;
    openFirewall = true;
    dhcpNoBind = true; # Use existing DHCP server.

    mode = "boot";
    kernel = "${build.kernel}/bzImage";
    initrd = "${build.netbootRamdisk}/initrd";
    cmdLine = "init=${build.toplevel}/init loglevel=4";
    debug = true;
  };
}
