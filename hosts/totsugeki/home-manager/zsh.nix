{ ... }: {
  home-manager.programs.zsh = {
    shellAliases = {
      "upload-music" =
        "rsync -a --chown=jellyfin:media --chmod=775 --remove-source-files ~/Música/* avery@10.0.0.1:/home/avery/music";
    };
  };
}
