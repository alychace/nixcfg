{self, ...}: {
  home-manager = {
    sharedModules = [
      {
        myHome.desktop.hyprland.laptopMonitor = "desc:LG Display 0x0569,preferred,auto,1.0";
      }
    ];

    users.aly = self.homeManagerModules.aly;
  };
}
