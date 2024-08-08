{
  "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";
  display = {separator = " -> ";};
  logo = {padding = {bottom = 2;};};
  modules = [
    {
      format = "[90m┌────────────────────────────────────────────────────────────┐";
      type = "custom";
    }
    {
      keyWidth = 10;
      type = "title";
    }
    {
      format = "[90m└────────────────────────────────────────────────────────────┘";
      type = "custom";
    }
    {
      format = " [90m  [31m  [32m  [33m  [34m  [35m  [36m  [37m  [38m  [39m       [38m  [37m  [36m  [35m  [34m  [33m  [32m  [31m  [90m";
      type = "custom";
    }
    {
      format = "[90m┌────────────────────────────────────────────────────────────┐";
      type = "custom";
    }
    {
      key = " OS";
      keyColor = "yellow";
      type = "os";
    }
    {
      key = "│ └";
      keyColor = "yellow";
      type = "shell";
    }
    {
      key = " DE/WM";
      keyColor = "blue";
      type = "wm";
    }
    {
      key = "│ ├󰉼";
      keyColor = "blue";
      type = "theme";
    }
    {
      key = "│ ├";
      keyColor = "blue";
      type = "terminal";
    }
    {
      key = "│ └󰸉";
      keyColor = "blue";
      type = "wallpaper";
    }
    {
      key = "󰌢 PC";
      keyColor = "green";
      type = "host";
    }
    {
      key = "│ ├󰻠";
      keyColor = "green";
      type = "cpu";
    }
    {
      key = "│ ├󰑭";
      keyColor = "green";
      type = "memory";
    }
    {
      key = "│ ├";
      keyColor = "green";
      type = "disk";
    }
    {
      key = "│ └󰍹";
      keyColor = "green";
      type = "display";
    }
    {
      key = "│ ├";
      keyColor = "green";
      type = "battery";
    }
    {
      key = " SND";
      keyColor = "cyan";
      type = "player";
    }
    {
      key = "│ └󰝚";
      keyColor = "cyan";
      type = "media";
    }
    {
      format = "[90m└────────────────────────────────────────────────────────────┘";
      type = "custom";
    }
    "break"
    {
      format = " [90m  [31m  [32m  [33m  [34m  [35m  [36m  [37m  [38m  [39m       [38m  [37m  [36m  [35m  [34m  [33m  [32m  [31m  [90m";
      type = "custom";
    }
  ];
}
