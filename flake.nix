{
  description = "Reproducible NixOS workstation";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, nixos-wsl, home-manager, ... }: {
    nixosConfigurations.wsl = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        nixos-wsl.nixosModules.default

        home-manager.nixosModules.home-manager

        ./hosts/wsl/default.nix

        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;

            users.nixos = import ./home/common.nix;
          };
        }
      ];
    };
  };
}

