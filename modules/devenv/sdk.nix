{ pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
    act
    arduino-cli
    arduino-ide
    clang
    delve
    deno
    dotnetCorePackages.sdk_10_0-bin
    esptool
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
    python314
    qemu
    ruby_3_4
    scaleway-cli
    terraform
    uv
    zulu
  ];

  # Ensure common native builds (Ruby gems, Rust bindgen) can find required headers/libs.
  environment.shellInit = ''
    export CPATH=${pkgs.libyaml.dev}/include''${CPATH:+:$CPATH}
    export LIBRARY_PATH=${pkgs.libyaml}/lib''${LIBRARY_PATH:+:$LIBRARY_PATH}
    export LIBCLANG_PATH=${pkgs.llvmPackages.libclang.lib}/lib
  '';

  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = [ "sysblade" ];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  virtualisation.docker = {
    enable = true;
  };

  users.users.sysblade.extraGroups = [ "docker" ];
}
