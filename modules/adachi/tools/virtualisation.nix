{ ... }:
{
  adachi.tools._.virtualisation =
    { user, ... }:
    {
      nixos =
        { pkgs, ... }:
        {
          programs.virt-manager.enable = true;
          virtualisation = {
            libvirtd.enable = true;
            spiceUSBRedirection.enable = true;
          };
          users.users.${user.userName}.extraGroups = [
            "libvirt"
            "kvm"
          ];
        };

      homeManager = {
        dconf.settings = {
          "org/virt-manager/virt-manager/connections" = {
            autoconnect = [ "qemu:///system" ];
            uris = [ "qemu:///system" ];
          };
        };
      };
    };
}
