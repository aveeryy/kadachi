{ self, ... }:
let
  neovim.setLanguageIndentation = pattern: indentation: /* lua */ ''
    vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
      pattern = "${pattern}",
      callback = function()
        vim.opt_local.shiftwidth = ${toString indentation}
        vim.opt_local.tabstop = ${toString indentation}
      end,
    })
  '';

  createBackupConfiguration = backupName: host: borgmaticConfiguration: {
    services.borgmatic.configurations.${backupName} = {
      archive_name_format = "{hostname}-${backupName}-{now:%Y-%m-%dT%H:%M:%S.%f}";
      repositories = host.services.backups.repositories backupName;
      encryption_passcommand = "cat /run/secrets/backups/password/${backupName}";
      ssh_command = "ssh -p 23 -i ${
        self.nixosConfigurations.${host.hostName}.config.sops.templates."backups_ssh_private_key".path
      }";
    }
    // borgmaticConfiguration;

    sops.secrets."backups/password/${backupName}".owner = "root";
  };
in
{
  _module.args.kadachi-lib = {
    inherit
      neovim
      createBackupConfiguration
      ;
  };
}
