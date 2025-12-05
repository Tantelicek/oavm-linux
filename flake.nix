{
  # Popisek
  description = "OAVM Linux - Main flake";

  # Vstupy na kterých flake staví
  inputs = {
    # NixOS officiální a aktuální stabilní zdroj balíčků 25.11
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    # NixOS officiální, nestabilní (bleeding edge) zdroj
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    # Flake Milánské univerzity Università degli Studi di Milano který obsahuje Imunes package
    imunes.url = "github:/Sesar-Lab-Teaching/Computer-Networks/master";
  };

  # Výstupy - lze volat pomocí příkazů nix, nixos-rebuild
  outputs = {
    self,
    nixpkgs,
    imunes,
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
        #{nix.settings.experimental-features = ["nix-command" "flakes"];}
      ];
    };

        
    nixosConfigurations.oavm-linux-h = nixpkgs.lib.nixosSystem {
      #system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        # Import klasického configuration.nix, jeho nastavení tak stále platí
        ./configuration.nix
        ./hardware/honza-vm/hardware-configuration.nix 
        #{nix.settings.experimental-features = ["nix-command" "flakes"];}
      ];
    };

    packages.x86_64-linux.default = pkgs.hello;

    packages.x86_64-linux.imunes = imunes.packages.x86_64-linux.imunes-before-break;

    packages.x86_64-linux.oavm-linux = pkgs.wireshark;
  };
}
