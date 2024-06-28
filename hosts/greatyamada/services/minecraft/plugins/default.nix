{ pkgs, ... }: {
  environment.systemPackages = with pkgs;
    [ (callPackage ./packages/essentialsx.nix { }) ];
}
