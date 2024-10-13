# Lenovo Legion Go
{
  config,
  pkgs,
  lib,
  self,
  ...
}: let
  adjustor = pkgs.callPackage ./adjustor.nix {};
  hhd-ui = pkgs.callPackage ./hhd-ui.nix {};
in {
  imports = [
    ./home.nix
    ./secrets.nix
    ./stylix.nix
    (import ./../../disko/luks-btrfs-subvolumes.nix {disks = ["/dev/nvme0n1"];})
    self.inputs.jovian.nixosModules.default
    self.nixosModules.common-base
    self.nixosModules.common-locale
    self.nixosModules.common-nix
    self.nixosModules.common-overlays
    self.nixosModules.common-pkgs
    self.nixosModules.common-tailscale
    self.nixosModules.common-wifi-profiles
    self.nixosModules.hw-lenovo-legion-go
  ];

  boot = {
    initrd.systemd.enable = true;

    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };

    loader = {
      efi.canTouchEfiVariables = true;

      systemd-boot = {
        enable = lib.mkForce false;
        consoleMode = "1";
      };
    };
  };

  environment = {
    systemPackages = [hhd-ui];

    variables = {
      FLAKE = lib.mkForce "github:alyraffauf/nixcfg/24.11";
      GDK_SCALE = "2";
    };
  };

  systemd.services.handheld-daemon.path = [hhd-ui pkgs.lsof];

  jovian = {
    decky-loader = {
      enable = true;
      user = "aly";
    };

    hardware.has.amd.gpu = true;

    steam = {
      enable = true;
      autoStart = true;
      desktopSession = "hyprland";
      user = "aly";
    };
  };

  networking.hostName = "pacifidlog";

  nixpkgs.overlays = [
    (final: prev: {
      brave = prev.brave.override {commandLineArgs = "--gtk-version=4 --enable-wayland-ime";};

      obsidian = prev.obsidian.overrideAttrs (old: {
        installPhase =
          builtins.replaceStrings ["--ozone-platform=wayland"]
          ["--ozone-platform=wayland --enable-wayland-ime"]
          old.installPhase;
      });

      vscodium = prev.vscodium.override {commandLineArgs = "--enable-wayland-ime";};

      webcord = prev.webcord.overrideAttrs (old: {
        installPhase =
          builtins.replaceStrings ["--ozone-platform-hint=auto"]
          ["--ozone-platform-hint=auto --enable-wayland-ime"]
          old.installPhase;
      });
    })
  ];

  services.handheld-daemon = {
    enable = true;
    user = "aly";

    package = with pkgs;
      handheld-daemon.overrideAttrs (oldAttrs: {
        propagatedBuildInputs =
          oldAttrs.propagatedBuildInputs
          ++ [
            adjustor
          ];
      });
  };

  system.stateVersion = "24.11";

  ar = {
    apps = {
      firefox.enable = true;
      steam.enable = true;
    };

    desktop.hyprland.enable = true;
    laptopMode = true;

    users.aly = {
      enable = true;
      password = "$y$j9T$CXjk5Z9e2PXbSsWh5CK.81$I9Hm/Oa4KcYMqPi8KMBfsEv5NzoXCgaCK5xhyGeikH7";

      syncthing = {
        enable = true;
        certFile = config.age.secrets.syncthingCert.path;
        keyFile = config.age.secrets.syncthingKey.path;
        syncMusic = false;
      };
    };
  };
}
