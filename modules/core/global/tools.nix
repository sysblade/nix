{
  pkgs,
  ...
}:

{
  environment.systemPackages = with pkgs; [

    # CLI utilities
    bat
    eza
    fd
    file
    fzf
    gawk
    gnupg
    gnutar
    jq
    neofetch
    ripgrep
    time
    tokei
    tree
    which
    yq-go

    # Nix related tools
    direnv
    nil
    nixd
    nixfmt-rfc-style

    # HTTP clients
    curl
    httpie
    wget

    # Monitoring
    acpi
    btop
    dnsutils
    htop
    iftop
    iotop
    lm_sensors
    lsof
    ltrace
    ncdu
    pciutils
    strace
    sysstat
    sysstat
    tcpdump
    usbutils

    # Backup and storage management
    kopia
    rclone

    # Archiving
    p7zip
    unzip
    xz
    zip
    zstd

    # Basic development tools
    git
    go-task
    lunarvim
    vim
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
  };

  programs.htop = {
    enable = true;
    settings = {
      hide_kernel_threads = false;
      hide_userlands_threads = false;
    };
  };

  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.fwupd.enable = true;
}
