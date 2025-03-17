{ pkgs, ... }: {
  programs = {
    autofirma = {
      enable = true;
      firefoxIntegration.profiles.Avery.enable = true;
    };
    firefox.policies.SecurityDevices = {
      "OpenSC PKCS11" = "${pkgs.opensc}/lib/opensc-pkcs11.so";
    };
  };
}
