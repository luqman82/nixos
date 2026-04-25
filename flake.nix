{
  description = "Lock the version of all installed packages.";

  inputs = {
   nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
     nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
  #   nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
  };

  outputs = { self, nixpkgs, nix-cachyos-kernel }: {

      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {

      system = "x86_64-linux";

      modules = [



      (
          { pkgs, ... }:
          {
            nixpkgs.overlays = [
              # Use nixpkgs from your environment, nixpkgs.config will apply.
              # Has small chance of kernel modules not being compatible with kernel version.
              #nix-cachyos-kernel.overlays.default

              # Alternatively, use the exact nixpkgs revison as defined in this repo.
              # Guarantees you have binary cache, but initializes another nixpkgs instance.
              nix-cachyos-kernel.overlays.pinned

              # Only use one of the two overlays!
            ];

            #nix.settings.substituters = [ "https://attic.xuyh0120.win/lantian" ];
            #nix.settings.trusted-public-keys = [ "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" ];

            # ... your other configs
          }
      )
           ./configuration.nix
      ];
      };
  };
}
