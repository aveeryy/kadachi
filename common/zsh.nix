{ config, ... }: {
  programs = {
    zsh = {
      enable = true;
      initExtra = ''
        bindkey "^[OA" history-beginning-search-backward-end
        bindkey "^[OB" history-beginning-search-forward-end
        bindkey "^r" history-incremental-search-backward

        zstyle ':completion::complete:*' use-cache on
        zstyle ':completion::complete:*' cache-path ~/.zsh/cache/$HOST
        zstyle ':completion:*' menu select=1 _complete _ignored _approximate
        zstyle ':completion:*' verbose yes
        zstyle ':completion:*:descriptions' format '%B%d%b'
        zstyle ':completion:*:messages' format '%d'
        zstyle ':completion:*:warnings' format 'No matches for: %d'
        zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
        zstyle ':completion:*' group-name \'\'
        zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

        fastfetch
      '';
      initExtraFirst = ''
        setopt AUTO_PUSHD
        setopt SHARE_HISTORY
        setopt MENUCOMPLETE
        autoload -U history-search-end
        zle -N history-beginning-search-backward-end history-search-end
        zle -N history-beginning-search-forward-end history-search-end
      '';
      history.path = "${config.xdg.dataHome}/zhistory";
      syntaxHighlighting.enable = true;
    };
    starship = {
      enable = true;
      settings = {
        add_newline = true;

      };
    };
  };
}
