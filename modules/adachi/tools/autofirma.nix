{ inputs, ... }:
{
  flake-file.inputs.autofirma-nix = {
    # url = "github:nix-community/autofirma-nix";
    url = "git+https://git.rcia.dev/Avery/autofirma-nix-fork";
    inputs = {
      flake-parts.follows = "flake-parts";
      home-manager.follows = "home-manager";
      nixpkgs.follows = "nixpkgs";
    };
  };

  adachi.tools._.autofirma = {
    homeManager = {
      imports = [ inputs.autofirma-nix.homeManagerModules.default ];
      programs.autofirma.enable = true;
    };
    provides = {
      firefox-integration = profileName: {
        homeManager =
          { pkgs, ... }:
          {
            programs = {
              autofirma.firefoxIntegration.profiles.${profileName}.enable = true;
              firefox.policies.SecurityDevices = {
                "OpenSC PKCS11" = "${pkgs.opensc}/lib/opensc-pkcs11.so";
              };
            };
          };
      };
    };
  };

}
