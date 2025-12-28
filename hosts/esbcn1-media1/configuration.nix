{ config, pkgs, ... }:

{
  imports = [
    ./hardware.nix
    ../../modules/core/server/default.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "esbcn1-media1";
  time.timeZone = "Europe/Madrid";

  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };
  environment.systemPackages = [
    pkgs.jellyfin
    pkgs.jellyfin-web
    pkgs.jellyfin-ffmpeg
  ];

  services.plex = {
    enable = true;
    openFirewall = true;
  };

  fileSystems."/mnt/esbcn1-nas1/mnt/dpool/public" = {
    device = "192.168.89.180:/mnt/dpool/public";
    fsType = "nfs";
  };
  
  services.qbittorrent = {
    enable = true;
    torrentingPort = 51413;
    webuiPort = 8080;
    openFirewall = true;
  };
}
