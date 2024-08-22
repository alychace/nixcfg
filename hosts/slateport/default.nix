{
  config,
  lib,
  pkgs,
  self,
  ...
}: let
  domain = "raffauflabs.com";
in {
  imports = [
    ../common
    ./disko.nix
    ./home.nix
    ./secrets.nix
    ./stylix.nix
    self.inputs.nixhw.nixosModules.common-intel-cpu
    self.inputs.nixhw.nixosModules.common-intel-gpu
    self.inputs.nixhw.nixosModules.common-bluetooth
    self.inputs.nixhw.nixosModules.common-ssd
    self.inputs.raffauflabs.nixosModules.raffauflabs
  ];

  boot = {
    initrd.availableKernelModules = ["xhci_pci" "ahci" "nvme" "usbhid" "sd_mod"];

    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
  };

  hardware.enableAllFirmware = true;
  networking.hostName = "slateport";
  system.stateVersion = "24.05";
  zramSwap.memoryPercent = 100;

  ar = {
    apps.podman.enable = true;

    users.aly = {
      enable = true;
      password = "$y$j9T$Lit66g43.Zn60mwGig7cx1$L.aLzGvy0q.b1E40/XSIkhj2tkJbigpXFrxR/D/FVB4";

      syncthing = {
        enable = true;
        certFile = config.age.secrets.syncthingCert.path;
        keyFile = config.age.secrets.syncthingKey.path;
        syncMusic = false;
      };
    };
  };

  raffauflabs = {
    inherit domain;
    enable = true;

    services.ddclient = {
      enable = true;
      passwordFile = config.age.secrets.cloudflare.path;
      protocol = "cloudflare";
    };
  };
}
