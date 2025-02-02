{
  config,
  lib,
  ...
}: {
  config = {
    services.gammastep = {
      enable = true;
      latitude = lib.mkDefault "33.74";
      longitude = lib.mkDefault "-84.38";
    };

    systemd.user.services.gammastep = {
      Install.WantedBy = lib.mkForce (lib.optional (config.wayland.windowManager.hyprland.enable) "hyprland-session.target");
      Service.Restart = lib.mkForce "no";
      Unit.BindsTo = lib.optional (config.wayland.windowManager.hyprland.enable) "hyprland-session.target";
    };
  };
}
