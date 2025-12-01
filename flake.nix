{
  # Popisek
  description = "OAVM Linux - Main flake";

  # Vstupy na kterých flake staví
  inputs = {
    # NixOS officiální a aktuální stabilní zdroj balíčků 25.05
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    imunes.url = "github:/Sesar-Lab-Teaching/Computer-Networks/master";
  };

  # Výstupy - výsledky buildu flaku
  outputs = {
    self,
    nixpkgs,
    ...
  }: let
  in {
    nixosConfigurations.oavm-linux = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        # Import klasického configuration.nix, jeho nastavení tak stále platí
        ./configuration.nix

        ./hardware-configuration.nix
      ];
    };

    #packages.x86_64-linux.imunes = derivation;

  };
}
