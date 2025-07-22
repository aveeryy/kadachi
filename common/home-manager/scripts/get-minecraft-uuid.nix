{ pkgs }:

pkgs.writeShellApplication {
  name = "get-minecraft-uuid";
  runtimeInputs = with pkgs; [ curl jq gnused ];
  text = ''
    usage() {
        echo "USAGE: get-minecraft-uuid USERNAME"
        exit 1
    }

    test -n "$1" || usage

    curl -s "https://api.mojang.com/users/profiles/minecraft/$1" | jq -r ".id" | sed -r "s/^(\w{8})(\w{4})(\w{4})(\w{4})(\w{12})$/\1-\2-\3-\4-\5/"
  '';
}
