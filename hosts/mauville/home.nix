{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  home-manager = {
    sharedModules = [
      {
        programs.vscode.userSettings = {
          "workbench.colorTheme" = lib.mkForce "Catppuccin Mocha";
          "workbench.iconTheme" = lib.mkForce "catppuccin-mocha";
        };

        xdg.userDirs.music = "/mnt/Media/Music";

        ar.home.desktop.hyprland.autoSuspend = false;
      }
    ];

    users.aly = lib.mkForce {
      imports = [../../homes/aly];
      systemd.user = {
        services = {
          backblaze-sync = {
            Unit = {
              Description = "Backup to Backblaze.";
            };
            Service = {
              ExecStart = "${pkgs.writeShellScript "backblaze-sync" ''
                declare -A backups
                backups=(
                  ['/home/aly/pics/camera']="b2://aly-camera"
                  ['/home/aly/sync']="b2://aly-sync"
                  ['/mnt/Archive/Archive']="b2://aly-archive"
                  ['/mnt/Media/Audiobooks']="b2://aly-audiobooks"
                  ['/mnt/Media/Music']="b2://aly-music"
                )
                # Recursively backup folders to B2 with sanity checks.
                for folder in "''${!backups[@]}"; do
                  if [ -d "$folder" ] && [ "$(ls -A "$folder")" ]; then
                    ${lib.getExe pkgs.backblaze-b2} sync --delete $folder ''${backups[$folder]}
                  else
                    echo "$folder does not exist or is empty."
                    exit 1
                  fi
                done
              ''}";
            };
          };

          build-hosts = {
            Unit = {
              Description = "Build nixosConfiguration for each host.";
            };
            Service = {
              ExecStart = "${pkgs.writeShellScript "build-hosts" ''
                hosts=(
                  fallarbor
                  lavaridge
                  petalburg
                  rustboro
                )

                for h in "''${hosts[@]}"; do
                  nix build github:alyraffauf/nixcfg#nixosConfigurations.$h.config.system.build.toplevel
                done
              ''}";
            };
          };
        };

        timers = {
          backblaze-sync = {
            Unit = {
              Description = "Daily backups to Backblaze.";
            };
            Install = {
              WantedBy = ["timers.target"];
            };
            Timer = {
              OnCalendar = "*-*-* 03:00:00";
            };
          };
          build-hosts = {
            Unit = {
              Description = "Build hosts daily.";
            };
            Install = {
              WantedBy = ["timers.target"];
            };
            Timer = {
              OnCalendar = "*-*-* 06:00:00";
            };
          };
        };
      };
    };
  };
}
