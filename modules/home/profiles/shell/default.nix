{...}: {
  config = {
    home.shellAliases = {
      cat = "bat";
      grep = "rg";
    };

    programs = {
      bash = {
        enable = true;
        enableCompletion = true;
        enableVteIntegration = true;

        shellOptions = [
          "autocd"
          "cdspell"
          "checkjobs"
          "checkwinsize"
          "dirspell"
          "dotglob"
          "extglob"
          "globstar"
          "histappend"
        ];

        initExtra = ''
          export PS1="[\[$(tput setaf 27)\]\u\[$(tput setaf 135)\]@\[$(tput setaf 45)\]\h:\[$(tput setaf 33)\]\w] \[$(tput sgr0)\]$ "
        '';
      };

      bat.enable = true;
      direnv.enable = true;

      eza = {
        enable = true;
        extraOptions = ["--group-directories-first" "--header"];
        git = true;
        icons = "auto";
      };

      fzf.enable = true;

      oh-my-posh = {
        enable = true;
        useTheme = "zash";
      };

      ripgrep = {
        enable = true;
        arguments = ["--pretty"];
      };

      yazi = {
        enable = true;
        enableBashIntegration = true;

        settings = {
          log.enabled = false;

          manager = {
            show_hidden = false;
            sort_by = "mtime";
            sort_dir_first = true;
            sort_reverse = true;
            sort_sensitive = true;
            linemode = "size";
            show_symlink = true;
          };

          preview.tab_size = 4;
        };
      };

      zellij.enable = true;

      zsh = {
        enable = true;
        autocd = true;
        autosuggestion.enable = true;
        enableCompletion = true;
        enableVteIntegration = true;
        historySubstringSearch.enable = true;

        history = {
          expireDuplicatesFirst = true;
          extended = true;
          ignoreAllDups = true;
        };
      };
    };
  };
}
