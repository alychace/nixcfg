{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./alacritty
    ./backblaze
    ./bash
    ./chromium
    ./emacs
    ./fastfetch
    ./firefox
    ./fuzzel
    ./keepassxc
    ./librewolf
    ./mako
    ./nemo
    ./swaylock
    ./thunar
    ./tmux
    ./vsCodium
    ./waybar
    ./wlogout
    ./zed
  ];
}
