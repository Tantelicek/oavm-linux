{
    description = "Školní OS s Plasmou a vlastní tapetou";

inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
};

outputs = { self, nixpkgs, ... }:
{
            nixosConfigurations.schoolPC = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [ ./hosts/schoolPC/configuration.nix ];
        };
    };
}
