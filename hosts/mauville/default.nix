# Beelink S12 Pro mini PC with Intel N100, 16GB RAM, 500GB SSD + 2TB SSD.
{
  config,
  self,
  ...
}: let
  mediaDirectory = "/mnt/Media";
in {
  imports = [
    ./disko.nix
    ./home.nix
    ./raffauflabs.nix
    ./secrets.nix
    self.nixosModules.hardware-beelink-mini-s12pro
    self.nixosModules.locale-en-us
  ];

  networking.hostName = "mauville";

  services = {
    samba = {
      enable = true;
      openFirewall = true;

      settings = {
        global = {
          security = "user";
          "read raw" = "Yes";
          "write raw" = "Yes";
          "socket options" = "TCP_NODELAY IPTOS_LOWDELAY SO_RCVBUF=131072 SO_SNDBUF=131072";
          "min receivefile size" = 16384;
          "use sendfile" = true;
          "aio read size" = 16384;
          "aio write size" = 16384;
        };

        Media = {
          "create mask" = "0755";
          "directory mask" = "0755";
          "force group" = "users";
          "force user" = "aly";
          "guest ok" = "yes";
          "read only" = "no";
          browseable = "yes";
          comment = "Media @ ${config.networking.hostName}";
          path = mediaDirectory;
        };
      };
    };

    samba-wsdd = {
      enable = true;
      openFirewall = true;
    };
  };

  system = {
    autoUpgrade.operation = "switch";
    stateVersion = "25.05";
  };

  time.timeZone = "America/New_York";

  myNixOS = {
    profiles = {
      autoUpgrade.enable = true;
      base.enable = true;
      btrfs.enable = true;
      server.enable = true;
      wifi.enable = true;
    };

    programs = {
      lanzaboote.enable = true;
      nix.enable = true;
      podman.enable = true;
    };

    services = {
      syncthing = {
        enable = true;
        certFile = config.age.secrets.syncthingCert.path;
        keyFile = config.age.secrets.syncthingKey.path;
        musicPath = "${mediaDirectory}/Music";
        syncMusic = true;
        syncROMs = true;
        user = "aly";
      };

      tailscale.enable = true;
    };
  };

  myUsers.aly = {
    enable = true;
    password = "$y$j9T$SHPShqI2IpRE101Ey2ry/0$0mhW1f9LbVY02ifhJlP9XVImge9HOpf23s9i1JFLIt9";
  };
}
