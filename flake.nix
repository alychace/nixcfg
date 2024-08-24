{
  description = "Aly's NixOS flake.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    agenix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:ryantm/agenix";
    };

    disko = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/disko";
    };

    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager/release-24.05";
    };

    iio-hyprland = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:JeanSchoeller/iio-hyprland";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixhw = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:alyraffauf/nixhw";
    };

    nur.url = "github:nix-community/NUR";

    raffauflabs = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:alyraffauf/raffauflabs";
    };

    stylix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:danth/stylix";
    };
  };

  nixConfig = {
    accept-flake-config = true;

    extra-substituters = [
      "https://alyraffauf.cachix.org"
      "https://nix-community.cachix.org"
    ];

    extra-trusted-public-keys = [
      "alyraffauf.cachix.org-1:GQVrRGfjTtkPGS8M6y7Ik0z4zLt77O0N25ynv2gWzDM="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  outputs = {self, ...}: let
    forDefaultSystems = self.inputs.nixpkgs.lib.genAttrs [
      "aarch64-linux"
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];

    forLinuxSystems = self.inputs.nixpkgs.lib.genAttrs [
      "aarch64-linux"
      "x86_64-linux"
    ];

    forAllHosts = self.inputs.nixpkgs.lib.genAttrs [
      "fallarbor"
      "lavaridge"
      "mauville"
      "petalburg"
      "rustboro"
      "slateport"
    ];
  in {
    formatter = forDefaultSystems (system: self.inputs.nixpkgs.legacyPackages.${system}.alejandra);

    packages = forLinuxSystems (system: {
      default = self.inputs.nixpkgs.legacyPackages."${system}".writeShellApplication {
        name = "clean-install";
        text = ./flake/clean-install.sh;
      };
    });

    homeManagerModules = {
      default = import ./homeManagerModules self;
      aly = import ./homes/aly/gui.nix self;
      aly-nox = import ./homes/aly/nox.nix self;
      dustin = import ./homes/dustin self;
      morgan = import ./homes/morgan self;
    };

    nixosModules = {
      common-auto-upgrade = import ./common/autoUpgrade.nix;
      common-base = import ./common/base.nix;
      common-locale = import ./common/locale.nix;
      common-mauville-share = import ./common/samba.nix;
      common-nix = import ./common/nix.nix;
      common-overlays = import ./common/overlays.nix;
      common-pkgs = import ./common/pkgs.nix;
      common-tailscale = import ./common/tailscale.nix;
      common-wifi-profiles = import ./common/wifi.nix;

      nixos = import ./nixosModules self;
      users = import ./userModules self;
    };

    nixosConfigurations = forAllHosts (
      host:
        self.inputs.nixpkgs.lib.nixosSystem {
          specialArgs = {inherit self;};
          modules = [
            ./hosts/${host}
            self.inputs.agenix.nixosModules.default
            self.inputs.disko.nixosModules.disko
            self.inputs.home-manager.nixosModules.home-manager
            self.inputs.stylix.nixosModules.stylix
            self.nixosModules.nixos
            self.nixosModules.users
            {
              home-manager = {
                backupFileExtension = "backup";
                extraSpecialArgs = {inherit self;};
                useGlobalPkgs = true;
                useUserPackages = true;
              };
            }
          ];
        }
    );
  };
}
