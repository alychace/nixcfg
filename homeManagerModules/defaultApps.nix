{
  config,
  lib,
  ...
}: let
  cfg = config.ar.home.defaultApps;
  mimeTypes = import ./mimeTypes.nix;
in {
  config = lib.mkIf cfg.enable {
    dconf = {
      enable = true;
      settings = {
        "org/cinnamon/desktop/applications/terminal".exec = "${lib.getExe cfg.terminal}";
        "org/cinnamon/desktop/default-applications/terminal".exec = "${lib.getExe cfg.terminal}";
      };
    };

    home = {
      packages = with cfg; [
        audioPlayer
        editor
        fileManager
        imageViewer
        pdfViewer
        terminal
        terminalEditor
        videoPlayer
        webBrowser
      ];

      sessionVariables = {
        BROWSER = "${lib.getExe cfg.webBrowser}";
        EDITOR = "${lib.getExe cfg.terminalEditor}";
        TERMINAL = "${lib.getExe cfg.terminal}";
      };
    };

    xdg = {
      mimeApps = {
        enable = true;

        defaultApplications = let
          mkDefaults = files: desktopFile: lib.genAttrs files (_: [desktopFile]);
          audioTypes =
            mkDefaults mimeTypes.audioFiles
            "defaultAudioPlayer.desktop";

          browserTypes =
            mkDefaults mimeTypes.browserFiles
            "defaultWebBrowser.desktop";

          documentTypes =
            mkDefaults mimeTypes.documentFiles
            "defaultPdfViewer.desktop";

          editorTypes =
            mkDefaults mimeTypes.editorFiles
            "defaultEditor.desktop";

          folderTypes = {"inode/directory" = "defaultFileManager.desktop";};

          imageTypes =
            mkDefaults mimeTypes.imageFiles
            "defaultImageViewer.desktop";

          videoTypes =
            mkDefaults mimeTypes.videoFiles
            "defaultVideoPlayer.desktop";
        in
          audioTypes
          // browserTypes
          // documentTypes
          // editorTypes
          // folderTypes
          // imageTypes
          // videoTypes;
      };

      desktopEntries = let
        mkDefaultEntry = name: package: {
          name = "Default ${name}";
          exec = "${lib.getExe package} %U";
          terminal = false;
          settings = {
            NoDisplay = "true";
          };
        };
      in {
        defaultAudioPlayer = mkDefaultEntry "Audio Player" cfg.audioPlayer;
        defaultEditor = mkDefaultEntry "Editor" cfg.editor;
        defaultFileManager = mkDefaultEntry "File Manager" cfg.fileManager;
        defaultImageViewer = mkDefaultEntry "Image Viewer" cfg.imageViewer;
        defaultPdfViewer = mkDefaultEntry "PDF Viewer" cfg.pdfViewer;
        defaultVideoPlayer = mkDefaultEntry "Video Player" cfg.videoPlayer;
        defaultWebBrowser = mkDefaultEntry "Web Browser" cfg.webBrowser;
      };
    };
  };
}
