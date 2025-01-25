{
  lib,
  pkgs,
  self,
  ...
}: {
  imports = [
    ../../common.nix
    ../common.nix
    ./equalizer.nix
    self.nixosModules.hardware-amd-cpu
    self.nixosModules.hardware-amd-gpu
    self.nixosModules.hardware-common
  ];

  boot = {
    initrd.availableKernelModules = ["nvme" "sd_mod" "thunderbolt" "usb_storage" "xhci_pci"];

    extraModprobeConfig = ''
      options snd_hda_intel power_save=1
    '';

    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;
  };

  networking.networkmanager = {
    enable = true;

    wifi = {
      backend = "iwd";
      powersave = true;
    };
  };
}
