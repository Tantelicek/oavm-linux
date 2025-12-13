{
  # Popisek
  description = "OAVM Linux - Main flake";

  # Vstupy na kterých flake staví
  inputs = {
    # NixOS oficiální a aktuální stabilní zdroj balíčků 25.11
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    # NixOS oficiální, nestabilní (bleeding edge) zdroj
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    # Home manager - oficiální zdroj, dědí nixpkgs
    home-manager = {
      url = "github:nix-community/home-manager";
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
  };

  # Výstupy - lze volat pomocí příkazů nix, nixos-rebuild
  outputs = {
    self,
    nixpkgs,
    imunes,
    home-manager,
    plasma-manager,
    ...
  } @ inputs: let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
  in {
    nixosConfigurations.oavm-linux-d = nixpkgs.lib.nixosSystem {
      #system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        # Import klasického configuration.nix, jeho nastavení tak stále platí
        ./configuration.nix
        ./hardware/dominik-pc/hardware-configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.sharedModules = [ plasma-manager.homeModules.plasma-manager ];

            # This should point to your home.nix path of course. For an example
            # of this see ./home.nix in this directory.
            home-manager.users.student = import ./home.nix;
           }
       
      ];
    };

        
    nixosConfigurations.oavm-linux-h = nixpkgs.lib.nixosSystem {
      #system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        # Import klasického configuration.nix, jeho nastavení tak stále platí
        ./configuration.nix
        ./hardware/honza-vm/hardware-configuration.nix 
        
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.sharedModules = [ plasma-manager.homeModules.plasma-manager ];

            # This should point to your home.nix path of course. For an example
            # of this see ./home.nix in this directory.
            home-manager.users.student = import ./home.nix;
          }

      ];
    };

    packages.x86_64-linux.default = pkgs.hello;

    packages.x86_64-linux.imunes = imunes.packages.x86_64-linux.imunes-before-break;

    packages.x86_64-linux.oavm-linux = pkgs.wireshark;
  };
}
