{
  description = "NixOS Bastion with WireGuard on AWS";

  # Inputs: dependencias externas
  inputs = {
    # Usamos nixpkgs 24.05 (estable)
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
  };

  # Outputs: lo que este flake produce
  outputs = { self, nixpkgs, ... }: {
    
    # Configuración del servidor bastion
    nixosConfigurations.bastion = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      
      modules = [
        ./configuration.nix
      ];
    };
  };
}
