{
  inputs,
  config,
  pkgs,
  lib,
  ...
}: {
  home-manager.users.aly = {
    imports = [../../aly.nix];
  };
}
