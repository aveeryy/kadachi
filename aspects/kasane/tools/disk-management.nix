{ ... }:
{
  kasane.tools._.disk-management = {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          kdePackages.partitionmanager
          qdiskinfo
        ];
      };
  };
}
