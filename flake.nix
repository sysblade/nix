{
  description = "Kedare NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nix-gaming.url = "github:fufexan/nix-gaming";
    home-manager.url = "github:nix-community/home-manager";
    agenix.url = "github:ryantm/agenix";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-hardware,
      agenix,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        esbcn1-nix-cache1 = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          system = "x86_64-linux";
          modules = [
            ./hosts/esbcn1-nix-cache1/configuration.nix
            agenix.nixosModules.default
          ];
        };
        esbcn1-nas1 = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          system = "x86_64-linux";
          modules = [
            ./hosts/esbcn1-nas1/configuration.nix
            agenix.nixosModules.default
          ];
        };
        esbcn1-media1 = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          system = "x86_64-linux";
          modules = [
            ./hosts/esbcn1-media1/configuration.nix
            agenix.nixosModules.default
          ];
        };
        garuda = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          system = "x86_64-linux";
          modules = [
            ./hosts/garuda/configuration.nix
            nixos-hardware.nixosModules.framework-13-7040-amd
            agenix.nixosModules.default
          ];
        };
        carbuncle = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          system = "x86_64-linux";
          modules = [
            ./hosts/carbuncle/configuration.nix
            agenix.nixosModules.default
          ];
        };
        bahamut = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          system = "x86_64-linux";
          modules = [
            ./hosts/bahamut/configuration.nix
            agenix.nixosModules.default
          ];
        };
      };
    };
}
