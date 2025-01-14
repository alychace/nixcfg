{
  config,
  self,
  ...
}: {
  imports = [
    ./home.nix
    ./raffauflabs.nix
    ./secrets.nix
    (import ./../../disko/btrfs-subvolumes.nix {disks = ["/dev/sda"];})
    self.nixosModules.common-locale
    self.nixosModules.common-mauville-share
    self.nixosModules.common-wifi-profiles
    self.nixosModules.hw-common
    self.nixosModules.hw-common-bluetooth
    self.nixosModules.hw-common-intel-cpu
    self.nixosModules.hw-common-intel-gpu
    self.nixosModules.hw-common-ssd
    self.nixosModules.nixos-profiles-autoUpgrade
    self.nixosModules.nixos-profiles-base
    self.nixosModules.nixos-profiles-btrfs
    self.nixosModules.nixos-profiles-serverOptimizations
    self.nixosModules.nixos-programs-nix
    self.nixosModules.nixos-programs-podman
    self.nixosModules.nixos-services-tailscale
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "sd_mod"];
  networking.hostName = "slateport";

  services = {
    fwupd.enable = true;
    syncthing.guiAddress = "0.0.0.0:8384";
  };

  stylix = {
    enable = false;
    image = "${self.inputs.wallpapers}/wallhaven-mp886k.jpg";
  };

  system.stateVersion = "24.05";

  ar.users.aly = {
    enable = true;
    password = "$y$j9T$Lit66g43.Zn60mwGig7cx1$L.aLzGvy0q.b1E40/XSIkhj2tkJbigpXFrxR/D/FVB4";

    syncthing = {
      enable = true;
      certFile = config.age.secrets.syncthingCert.path;
      keyFile = config.age.secrets.syncthingKey.path;
    };
  };
}
