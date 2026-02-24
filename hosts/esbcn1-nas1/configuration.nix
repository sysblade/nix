{ pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ../../modules/core/server/default.nix
  ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/disk/by-id/ata-Emtec_X150_480GB_J28619R000207"; # or "nodev" for efi only
  boot.zfs.extraPools = [ "dpool" ];
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.forceImportRoot = false;

  services.zfs.autoScrub.enable = true;

  networking.hostName = "esbcn1-nas1";
  networking.hostId = "60bd0ba4";
  time.timeZone = "Europe/Madrid";

  #  fileSystems."/mnt/dpool" = {
  #    device = "dpool";
  #    fsType = "zfs";
  #    options = [ "zfsutil" ];
  #  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server string" = "smbnix";
        "netbios name" = "smbnix";
        "security" = "user";
        "guest account" = "nobody";
        "map to guest" = "bad user";
        "case sensitive" = "true";
        "default case" = "lower";
        "preserve case" = "true";
        "short preserve case" = "true";
      };
      "public" = {
        "path" = "/mnt/dpool/public";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
      };
      "private" = {
        "path" = "/mnt/dpool/private";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  services.nfs.server = {
    enable = true;
    lockdPort = 4001;
    mountdPort = 4002;
    statdPort = 4000;
    exports = ''
      /mnt/dpool/public 192.168.131.5(rw,no_subtree_check)
      /mnt/dpool/public 192.168.131.15(rw,no_subtree_check,no_root_squash)
      /mnt/dpool/public 192.168.131.16(rw,no_subtree_check,no_root_squash)
      /mnt/dpool/pve 192.168.131.201(rw,no_subtree_check)
      /mnt/dpool/pve 192.168.131.202(rw,no_subtree_check)
      /mnt/dpool/pve 192.168.131.203(rw,no_subtree_check)
      /mnt/dpool/pbs 192.168.131.4(sec=sys,rw,anonuid=0,anongid=0,no_root_squash,no_subtree_check)
    '';
  };
  networking.firewall = {
    allowedTCPPorts = [
      111
      2049
      4000
      4001
      4002
      20048
    ];
    allowedUDPPorts = [
      111
      2049
      4000
      4001
      4002
      20048
    ];
  };

  systemd.timers."kopia-backup" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
      Unit = "kopia-backup.service";
    };
  };

  systemd.services."kopia-backup" = {
    script = ''
      set -eu
      ${pkgs.kopia}/bin/kopia snapshot create /mnt/dpool
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };
}
