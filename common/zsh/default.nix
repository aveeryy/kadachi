{ config, pkgs, ...}:
let
  normalTheme = ./powerline10k/p10k.zsh;
  ttyTheme = ./powerline10k/p10k-tty.zsh;
in {
  programs.zsh = {
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

      if zmodload zsh/terminfo && (( terminfo[colors] >= 256 )); then
        [[ ! -f ${normalTheme} ]] || source ${normalTheme}
      else
        [[ ! -f ${ttyTheme} ]] || source ${ttyTheme}
      fi

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
    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];
    syntaxHighlighting.enable = true;
  };
}
