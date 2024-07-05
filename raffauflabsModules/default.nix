inputs: {
  config,
  pkgs,
  lib,
  ...
}: let
  mediaDirectory = "/mnt/Media";
  archiveDirectory = "/mnt/Archive";
in {
  imports = [
    ./containers
    ./options.nix
    ./services
  ];

  config = lib.mkIf config.raffauflabs.enable {
    age.secrets = {
      cloudflare.file = ../secrets/cloudflare.age;
      nixCache.file = ../secrets/nixCache/privKey.age;
    };

    networking.firewall.allowedTCPPorts = [80 443];

    security.acme = {
      acceptTerms = true;
      defaults.email = config.raffauflabs.email;
    };

    services = {
      ddclient = {
        enable = true;
        domains = [config.raffauflabs.domain];
        interval = "10min";
        passwordFile = config.age.secrets.cloudflare.path;
        protocol = "cloudflare";
        ssl = true;
        use = "web, web=dynamicdns.park-your-domain.com/getip, web-skip='Current IP Address: '";
        username = "token";
        zone = config.raffauflabs.domain;
      };

      fail2ban.enable = true;

      nginx = {
        enable = true;
        recommendedGzipSettings = true;
        recommendedProxySettings = true;
        recommendedTlsSettings = true;

        virtualHosts = {
          "nixcache.${config.raffauflabs.domain}" = {
            enableACME = true;
            forceSSL = true;

            locations."/".proxyPass = "http://${config.services.nix-serve.bindAddress}:${
              toString config.services.nix-serve.port
            }";
          };
        };
      };

      nix-serve = {
        enable = true;
        secretKeyFile = config.age.secrets.nixCache.path;
      };

      samba = {
        enable = true;
        openFirewall = true;
        securityType = "user";

        shares = {
          Media = {
            browseable = "yes";
            comment = "Media @ ${config.raffauflabs.domain}";
            path = mediaDirectory;
            "read only" = "no";
            "guest ok" = "yes";
            "create mask" = "0755";
            "directory mask" = "0755";
          };

          Archive = {
            browseable = "yes";
            comment = "Archive @ ${config.raffauflabs.domain}";
            path = archiveDirectory;
            "create mask" = "0755";
            "directory mask" = "0755";
            "guest ok" = "yes";
            "read only" = "no";
          };
        };
      };

      samba-wsdd = {
        enable = true;
        openFirewall = true;
      };
    };
  };
}
