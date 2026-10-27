{ pkgs, ... }:
{
  imports = [
    ./hyprland.nix
    ./quickshell.nix
  ];

  home.packages = with pkgs; [
    kitty
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-color-emoji
    papirus-icon-theme
  ];

  fonts.fontconfig.enable = true;

  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 12;
    };
    settings = {
      enable_audio_bell = false;
      background = "#111827";
      foreground = "#e5e7eb";
      background_opacity = "0.97";
      window_padding_width = 8;
    };
  };

  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland;xcb";
  };
}
