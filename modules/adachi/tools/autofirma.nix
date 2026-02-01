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

  adachi.tools._.autofirma = firefoxProfileName: {
    homeManager =
      { pkgs, lib, ... }:
      {
        imports = [ inputs.autofirma-nix.homeManagerModules.default ];
        programs = {
          autofirma = {
            enable = true;
          }
          // lib.optionalAttrs (firefoxProfileName != null) {
            firefoxIntegration.profiles.${firefoxProfileName}.enable = true;
          };
          firefox.policies.SecurityDevices = {
            "OpenSC PKCS11" = "${pkgs.opensc}/lib/opensc-pkcs11.so";
          };
        };
      };
  };

}
