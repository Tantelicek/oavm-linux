{
  # Popisek
  description = "OAVM Linux - Main flake";

  # Výstupy - lze volat pomocí příkazů nix, nixos-rebuild
  outputs = inputs @ {self, ...}: let
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    system = "x86_64-linux";
  in {
    nixosConfigurations.oavm-linux-d = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        # Import klasického configuration.nix, jeho nastavení tak stále platí
        ./configuration.nix
        ./hardware/dominik-pc/hardware-configuration.nix
        #(import ./overlays)

        {temporary.enable = false;}

        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.sharedModules = [inputs.plasma-manager.homeModules.plasma-manager];
          home-manager.users.student = import ./home.nix;
        }
      ];
    };

    nixosConfigurations.oavm-linux-h = inputs.nixpkgs.lib.nixosSystem {
      #system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        # Import klasického configuration.nix, jeho nastavení tak stále platí
        ./configuration.nix
        ./hardware/honza-vm/hardware-configuration.nix
        ./modules/temporary
        #(import ./overlays)

        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.sharedModules = [inputs.plasma-manager.homeModules.plasma-manager];
          home-manager.users.student = import ./home.nix;
        }
      ];

      dev.temporary.enable = true;
    };

    nixosConfigurations.oavm-linux-iso = inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        # Import klasického configuration.nix, jeho nastavení tak stále platí
        ./configuration.nix

        ({
          pkgs,
          modulesPath,
          ...
        }: {
          imports = [(modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")];
        })
        #(import ./overlays)

        inputs.home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.sharedModules = [inputs.plasma-manager.homeModules.plasma-manager];
          home-manager.users.student = import ./home.nix;
        }
      ];
    };
  };

  # Vstupy na kterých flake staví
  inputs = {
    # NixOS oficiální a aktuální stabilní zdroj balíčků 25.11
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    # NixOS oficiální, nestabilní (bleeding edge) zdroj
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    # Home manager - oficiální zdroj, dědí nixpkgs
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    # Plasma manager - konfigurace plasmy, dědí nixpkgs a home manager
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.home-manager.follows = "home-manager";
    };

    # Flake Milánské univerzity Università degli Studi di Milano který obsahuje Imunes package
    imunes.url = "github:/Sesar-Lab-Teaching/Computer-Networks/master";

    # Stylix
    stylix = {
      url = "github:nix-community/stylix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # Nix-flatpak
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
  };
}
