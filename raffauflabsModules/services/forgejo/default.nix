{
  config,
  lib,
  pkgs,
  ...
}: {
  config = lib.mkIf config.raffauflabs.services.forgejo.enable {
    services = {
      ddclient.domains = ["git.${config.raffauflabs.domain}"];

      forgejo = {
        enable = true;
        lfs.enable = true;

        settings = {
          actions = {
            ENABLED = true;
            DEFAULT_ACTIONS_URL = "https://github.com";
          };

          cron = {
            ENABLED = true;
            RUN_AT_START = false;
          };

          DEFAULT.APP_NAME = "Git @ RaffaufLabs.com";

          repository = {
            DEFAULT_BRANCH = "master";
            ENABLE_PUSH_CREATE_ORG = true;
            ENABLE_PUSH_CREATE_USER = true;
            PREFERRED_LICENSES = "GPL-3.0";
          };

          federation.ENABLED = true;
          picture.ENABLE_FEDERATED_AVATAR = true;
          security.PASSWORD_CHECK_PWN = true;

          server = {
            LANDING_PAGE = "explore";
            ROOT_URL = "https://git.${config.raffauflabs.domain}/";
          };

          service = {
            ALLOW_ONLY_INTERNAL_REGISTRATION = true;
            DISABLE_REGISTRATION = false;
            ENABLE_NOTIFY_MAIL = true;
          };

          session.COOKIE_SECURE = true;

          ui.DEFAULT_THEME = "forgejo-auto";
          "ui.meta" = {
            AUTHOR = "Git @ RaffaufLabs.com";
            DESCRIPTION = "Self-hosted git projects + toys.";
            KEYWORDS = "git,forge,forgejo,aly raffauf";
          };
        };
      };

      nginx.virtualHosts."git.${config.raffauflabs.domain}" = {
        enableACME = true;
        forceSSL = true;

        locations."/" = {
          proxyPass = "http://${config.services.forgejo.settings.server.HTTP_ADDR}:${toString config.services.forgejo.settings.server.HTTP_PORT}";

          extraConfig = ''
            client_max_body_size 512M;
          '';
        };
      };
    };
  };
}
