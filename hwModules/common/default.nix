{
  config,
  lib,
  ...
}: {
  console.useXkbConfig = true;

  hardware = {
    enableAllFirmware = true;
    keyboard.qmk.enable = true;

    logitech.wireless = {
      enable = true;
      enableGraphical = lib.mkDefault config.services.xserver.enable;
    };
  };

  services = {
    logind = {
      powerKey = "suspend";
      powerKeyLongPress = "poweroff";
    };

    udev.extraRules = ''
      # Disable Fn Lock for ThinkPad Trackpoint USB/Bluetooth Keyboard
      SUBSYSTEM=="hid", DRIVER=="lenovo", ATTRS{idVendor}=="17ef", ATTRS{idProduct}=="6047|60ee", ATTR{fn_lock}="0"
      SUBSYSTEM=="input", ATTRS{id/vendor}=="17ef", ATTRS{id/product}=="6048|60e1", TEST=="/sys/$devpath/device/fn_lock", RUN+="/bin/sh -c 'echo 0 > \"/sys/$devpath/device/fn_lock\"'"
    '';
  };

  zramSwap.enable = lib.mkDefault true;
}
