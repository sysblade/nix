{
  pkgs,
  ...
}:

{
  users.groups.sysblade = {
    gid = 1000;
  };
  users.users.sysblade = {
    uid = 1000;
    isNormalUser = true;
    group = "sysblade";
    extraGroups = [
      "wheel"
      "networkmanager"
      "dialout"
    ];
    shell = pkgs.zsh;

#    openssh.authorizedKeys.keys =
#      let
#        authorizedKeys = pkgs.fetchurl {
#          url = "https://codeberg.org/sysblade.keys";
#          sha256 = "sha256-sha256-Px9QiqHDNLUjir/xsHFKJliTs+Qage8j3Y7oLBjoz/0=";
#        };
#      in
#      pkgs.lib.splitString "\n" (builtins.readFile authorizedKeys);

  };
}
