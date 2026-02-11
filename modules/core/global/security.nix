{ ... }:

{
  services.fail2ban = {
    enable = true;
    maxretry = 10;
    ignoreIP = [
      "192.168.128.0/20"
      "2a0f:de00:fe00:5000::/56"
    ];
    jails = {
      sshd = {
        enabled = true;
      };
    };
  };
}
