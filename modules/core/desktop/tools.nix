{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    aspell
    aspellDicts.en
    aspellDicts.es
    aspellDicts.fr
    calibre
    ffmpeg-full
    gimp3-with-plugins
    google-chrome
    hunspell
    hunspellDicts.en-us-large
    hunspellDicts.es-es
    hunspellDicts.fr-moderne
    libreoffice
    nextcloud-client
    vlc
    vscode
    wezterm
    wireshark
    yt-dlp
  ];

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      fira-sans
      nerd-fonts._0xproto
      nerd-fonts.droid-sans-mono
      nerd-fonts.fira-code
    ];
    fontconfig = {
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
    polkitPolicyOwners = [ "kedare" ];
  };
  programs.firefox.enable = true;
  programs.thunderbird.enable = true;
}
