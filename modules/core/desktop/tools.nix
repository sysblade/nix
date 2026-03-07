{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    aspell
    aspellDicts.en
    aspellDicts.es
    aspellDicts.fr
    bitwarden-cli
    bitwarden-desktop
    cabextract
    calibre
    ffmpeg-full
    gimp3-with-plugins
    google-chrome
    hunspell
    hunspellDicts.en-us-large
    hunspellDicts.es-es
    hunspellDicts.fr-moderne
    inkscape
    libreoffice
    nextcloud-client
    qFlipper
    remmina
    vlc
    vscode
    wezterm
    winbox4
    wineWowPackages.stable
    winetricks
    wireshark
    xkill
    yt-dlp
  ];

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      fira-sans
      nerd-fonts._0xproto
      nerd-fonts.droid-sans-mono
      nerd-fonts.fira-code
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "0xProto Nerd Font" ];
        sansSerif = [ "Fira Sans" ];
        serif = [ "DejaVu Serif" ];
      };
    };
  };

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    polkitPolicyOwners = [ "sysblade" ];
  };
  programs.firefox.enable = true;
  programs.thunderbird.enable = true;

  services.flatpak.enable = true;

  nixpkgs.config.permittedInsecurePackages = [
    "electron-36.9.5"
  ];
}
