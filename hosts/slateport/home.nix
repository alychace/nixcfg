{
  lib,
  self,
  ...
}: {
  home-manager.users.aly = lib.mkForce (
    {pkgs, ...}: {
      imports = [self.homeManagerModules.default];

      home = {
        homeDirectory = "/home/aly";

        packages = with pkgs; [
          curl
        ];

        stateVersion = "24.05";
        username = "aly";
      };

      programs = {
        helix = {
          enable = true;
          defaultEditor = true;
        };

        home-manager.enable = true;
      };

      myHome = {
        profiles.shell.enable = true;
        programs.fastfetch.enable = true;
      };
    }
  );
}
