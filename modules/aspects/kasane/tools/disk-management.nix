{ ... }:
{
  kasane.tools._.disk-management = {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          gparted
          qdiskinfo
        ];
      };
  };
}
