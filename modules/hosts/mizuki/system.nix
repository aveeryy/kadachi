{ __findFile, ... }:
{
  den.hosts.x86_64-linux.mizuki = {
    services.wireguard = {
      nodeEnabled = true;
      addresses = [ "10.10.0.3/16" ];
      publicKey = "MbVmCHiEXd81GmmKl6lpy559o3Peho/4I0IbbOH8qU0=";
    };
    users.avery = { };
  };

  den.aspects.mizuki = {
    includes = [
      <adachi/services/podman>
      <kasane/services/wireguard>
      <megurine/is/wsl>
    ];

    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = with pkgs; [
          (podman-compose.overrideAttrs (_: {
            src = fetchFromGitHub {
              owner = "containers";
              repo = "podman-compose";
              rev = "ed3ec99699f692de5440c929ee9e7bfb116871c2";
              hash = "sha256-OxuWnyxhT6sjH6K5b+7KTx4z8DLLn5sLFUDto9Pa6EY=";
            };
          }))
        ];
        time.timeZone = "Europe/Madrid";
      };
  };
}
