{ pkgs, ... }:
let portDefinitions = import ../_port-definitions.nix;
in {
  environment.systemPackages = with pkgs; [ inv-sig-helper ];
  systemd.services.inv-sig-helper = {
    enable = true;
    after = [ "syslog.target" "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      User = "invidious";
      Group = "invidious";
      ExecStart =
        "${pkgs.inv-sig-helper}/bin/inv_sig_helper_rust --tcp 127.0.0.1:${
          toString portDefinitions.inv-sig-helper
        }";
      Restart = "always";
      RestartSec = "2s";
      Type = "simple";
      WorkingDirectory = "/tmp";
      BindPaths = "/tmp";
      CapabilityBoundingSet = [
        "~CAP_SETUID CAP_SETGID CAP_SETPCAP"
        "~CAP_SYS_ADMIN"
        "~CAP_SYS_PTRACE"
        "~CAP_CHOWN CAP_FSETID CAP_SETFCAP"
        "~CAP_DAC_OVERRIDE CAP_DAC_READ_SEARCH CAP_FOWNER CAP_IPC_OWNER"
        "~CAP_NET_ADMIN"
        "~CAP_SYS_MODULE"
        "~CAP_SYS_RAWIO"
        "~CAP_SYS_TIME"
        "~CAP_AUDIT_CONTROL CAP_AUDIT_READ CAP_AUDIT_WRITE"
        "~CAP_KILL"
        "~CAP_NET_BIND_SERVICE CAP_NET_BROADCAST CAP_NET_RAW"
        "~CAP_SYSLOG"
        "~CAP_SYS_NICE CAP_SYS_RESOURCE"
        "~CAP_MAC_ADMIN CAP_MAC_OVERRIDE"
        "~CAP_SYS_BOOT"
        "~CAP_LINUX_IMMUTABLE"
        "~CAP_IPC_LOCK"
        "~CAP_SYS_CHROOT"
        "~CAP_BLOCK_SUSPEND"
        "~CAP_LEASE"
        "~CAP_SYS_PACCT"
        "~CAP_SYS_TTY_CONFIG"
        "~CAP_WAKE_ALARM"
      ];
      LockPersonality = true;
      MemoryDenyWriteExecute = true;
      NoNewPrivileges = true;
      PrivateDevices = true;
      PrivateTmp = true;
      PrivateUsers = true;
      ProcSubset = "pid";
      ProtectControlGroups = true;
      ProtectHome = "tmpfs";
      ProtectHostname = true;
      ProtectKernelLogs = true;
      ProtectKernelModules = true;
      ProtectKernelTunables = true;
      ProtectProc = "invisible";
      ProtectSystem = "strict";
      RemoveIPC = true;
      RestrictAddressFamilies = "AF_INET AF_INET6 AF_UNIX";
      RestrictNamespaces = true;
      RestrictSUIDSGID = true;
      RestrictRealtime = true;
      SystemCallArchitectures = "native";
      SystemCallFilter = [
        "~@clock"
        "~@debug"
        "~@module"
        "~@mount"
        "~@raw-io"
        "~@reboot"
        "~@swap"
        "~@privileged"
        "~@resources"
        "~@cpu-emulation"
        "~@obsolete"
      ];
    };
  };
}
