{ pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    act
    clang
    delve
    gcc
    gnumake
    go
    golangci-lint
    gopls
    gotests
    gox
    impl
    libpq
    libyaml
    libyaml.dev
    llvmPackages.libcxxClang
    nodejs_24
    perl
    poetry
    postgresql
    postgresql.pg_config
    python313Full
    python313Packages.pip
    python313Packages.virtualenv
    qemu
    ruby_3_4
    terraform
    uv
    zulu24
  ];

  # Ensure common native builds (Ruby gems, Rust bindgen) can find required headers/libs.
  environment.shellInit = ''
    export CPATH=${pkgs.libyaml.dev}/include''${CPATH:+:$CPATH}
    export LIBRARY_PATH=${pkgs.libyaml}/lib''${LIBRARY_PATH:+:$LIBRARY_PATH}
    export LIBCLANG_PATH=${pkgs.llvmPackages.libclang.lib}/lib
  '';

  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = [ "kedare" ];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  virtualisation.docker = {
    enable = true;
  };

  users.users.kedare.extraGroups = [ "docker" ];
}
