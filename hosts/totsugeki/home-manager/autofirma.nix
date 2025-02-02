{ config, pkgs, ... }: {
  programs = {
    autofirma = {
      enable = true;
      firefoxIntegration.profiles.Avery.enable = true;
    };
    dnieremote = {
      enable = true;
      usbPort = 9500;
    };
    firefox.policies.SecurityDevices = {
      "OpenSC PKCS11" = "${pkgs.opensc}/lib/opensc-pkcs11.so";
      "DNIeRemote" =
        "${config.programs.dnieremote.finalPackage}/lib/libdnieremotepkcs11.so";
    };
  };
}
