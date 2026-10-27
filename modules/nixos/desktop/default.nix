{ pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  services.displayManager.ly.enable = true;

  security.polkit.enable = true;
  security.pam.services.hyprlock = {};
  programs.dconf.enable = true;
  services.libinput.enable = true;

  # Native Wayland desktop peripherals; none of these are enabled for WSL.
  hardware.graphics.enable = true;
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  security.rtkit.enable = true;

  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  environment.systemPackages = with pkgs; [
    hyprpolkitagent
    networkmanagerapplet
    pavucontrol
    brightnessctl
    wl-clipboard
    grim
    slurp
    playerctl
    libnotify
  ];
}
