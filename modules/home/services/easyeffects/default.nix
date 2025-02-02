{
  lib,
  config,
  ...
}: {
  options.myHome.services.easyeffects.preset = lib.mkOption {
    description = "Name of preset to start with.";
    default = "";
    type = lib.types.str;
  };

  config = {
    xdg.configFile = {
      "easyeffects/output/framework13.json".source = ./framework13.json;
      "easyeffects/output/fw13-autogain.json".source = ./fw13-autogain.json;
      "easyeffects/output/fw13-easy-effects.json".source = ./framework13.json;
      "easyeffects/output/LoudnessEqualizer.json".source = ./LoudnessEqualizer.json;
      "easyeffects/output/AdvancedAutoGain.json".source = ./AdvancedAutoGain.json;
    };

    services.easyeffects = {
      enable = true;
      preset = config.myHome.services.easyeffects.preset;
    };
  };
}
