{ pkgs, inputs, ... }:

{
  imports = [
    ./hardware.nix
    ../../modules/core/desktop/default.nix
    ../../modules/devenv/default.nix
    ../../modules/gaming/default.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "bahamut";
  time.timeZone = "Europe/Madrid";

  boot.initrd.systemd.enable = true;
  boot.swraid.enable = true;

  boot.initrd.luks.devices = {
    cryptoroot = {
      device = "/dev/disk/by-uuid/afc64c81-9f4b-4665-8f45-095d4d9d1a6b";
      allowDiscards = true;
    };

    cryptdata = {
      device = "/dev/disk/by-uuid/0e1fb849-8370-40e3-b986-a1894b3f25e2";
      allowDiscards = true;
    };
  };

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    nvidia = {
      open = false;
      powerManagement = {
        enable = true;
        finegrained = false;
      };
      nvidiaSettings = true;
    };
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  systemd.services."systemd-suspend" = {
    serviceConfig = {
      Environment = "SYSTEMD_SLEEP_FREEZE_USER_SESSIONS=false";
    };
  };
}
