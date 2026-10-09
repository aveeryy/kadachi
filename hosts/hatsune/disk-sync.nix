{ lib, ... }:
let
  inherit (lib)
    getExe
    ;
in
{
  hosts.hatsune.nixos = { pkgs, ... }: {
    systemd = {
      services."disk-sync" = {
        enable = true;
        description = "Sync the main drive with the backup";
        serviceConfig.Type = "oneshot";
        script = ''
          ${getExe pkgs.rsync} -av /mnt/disk0/ /mnt/disk1/
        '';
      };
      timers."disk-sync" = {
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnCalendar = "*-*-* 04:00";
          Persistent = true;
          Unit = "disk-sync.service";
        };
      };
    };
  };
}
