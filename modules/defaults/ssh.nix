{ ... }: {
  den.default = {
    nixos =
      { ... }:
      {
        programs.ssh.extraConfig = ''
          AddKeysToAgent yes
        '';

        services.openssh = {
          enable = true;
          settings = {
            PasswordAuthentication = false;
            PermitRootLogin = "no";
            X11Forwarding = false;
          };
        };
      };

    homeManager = {
      services.ssh-agent.enable = true;
    };
  };
}
