{ lib, ... }:
{
  kasane.zsh = {
    nixos =
      { pkgs, ... }:
      {
        environment = {
          pathsToLink = [ "/share/zsh" ];
          shells = with pkgs; [ zsh ];
        };
        programs.zsh.enable = true;
        users.defaultUserShell = pkgs.zsh;
      };
    homeManager =
      { config, ... }:
      {
        programs = {
          zsh = {
            enable = true;
            initContent = lib.mkBefore ''
              setopt AUTO_PUSHD
              setopt SHARE_HISTORY
              setopt MENUCOMPLETE
              autoload -U history-search-end
              bindkey -v
              zle -N history-beginning-search-backward-end history-search-end
              zle -N history-beginning-search-forward-end history-search-end
              bindkey "^[OA" history-beginning-search-backward-end
              bindkey "^[OB" history-beginning-search-forward-end
              bindkey "^r" history-incremental-search-backward
              bindkey ^S history-incremental-search-forward

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
            '';
            history.path = "${config.xdg.dataHome}/zhistory";
            shellAliases = {
              "nv" = "nvim";
              "nx" = "cd /etc/nixos && nvim";
              "print-nix-store-gc-roots" =
                ''nix-store --gc --print-roots | egrep -v "^(/nix/var|/run/\w+-system|\{memory|/proc)"'';
              "rbd" = ''nixos-rebuild --flake "path:/etc/nixos#$(hostname)" --sudo'';
              "rbd-remote" =
                ''nixos-rebuild --flake "git+https://git.rcia.dev/Avery/kadachi#$(hostname) --sudo"'';
            };
            syntaxHighlighting.enable = true;
            dotDir = "${config.xdg.configHome}/zsh";
          };
          starship = {
            enable = true;
            settings = {
              add_newline = true;
            };
          };
        };
      };
  };
}
