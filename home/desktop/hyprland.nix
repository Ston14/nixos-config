{ lib, ... }:
let
  lua = lib.generators.mkLuaInline;
  cmd = s: lua ("hl.dsp.exec_cmd(" + builtins.toJSON s + ")");
  act = s: lua s;
  key = combo: action: { _args = [ combo action ]; };
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    systemd.enable = false; # UWSM handles this.
    configType = "lua";

    settings = {
      config = {
        input = {
          kb_layout = "fr";
          follow_mouse = 1;
          touchpad.natural_scroll = true;
        };
        general = {
          gaps_in = 5;
          gaps_out = 12;
          border_size = 2;
          layout = "dwindle";
          col.active_border = "rgba(7aa2f7ee)";
          col.inactive_border = "rgba(323747aa)";
        };
        decoration.rounding = 10;
        animations.enabled = true;
        misc = {
          disable_hyprland_logo = true;
          force_default_wallpaper = 0;
          background_color = "0xff111827";
        };
      };
      monitor = [ { output = ""; mode = "preferred"; position = "auto"; scale = 1; } ];
      # Hyprland >=0.55 starts applications via Lua events.
      on = [{
        _args = [
          "hyprland.start"
          (lua ''
            function()
              hl.exec_cmd("uwsm app -- quickshell -c ade")
              hl.exec_cmd("uwsm app -- nm-applet --indicator")
              hl.exec_cmd("systemctl --user start hyprpolkitagent")
            end
          '')
        ];
      }];
      bind = [
        (key "SUPER + Return" (cmd "uwsm app -- kitty"))
        (key "SUPER + D" (cmd "quickshell -c ade ipc call launcher toggle"))
        (key "SUPER + Q" (act "hl.dsp.window.close()"))
        (key "SUPER + F" (act ''hl.dsp.window.fullscreen({ action = "toggle" })''))
        (key "SUPER + L" (cmd "uwsm app -- hyprlock"))
        (key "SUPER + left" (act ''hl.dsp.focus({ direction = "left" })''))
        (key "SUPER + right" (act ''hl.dsp.focus({ direction = "right" })''))
        (key "SUPER + up" (act ''hl.dsp.focus({ direction = "up" })''))
        (key "SUPER + down" (act ''hl.dsp.focus({ direction = "down" })''))
        (key "SUPER + ampersand" (act ''hl.dsp.focus({ workspace = 1 })''))
        (key "SUPER + eacute" (act ''hl.dsp.focus({ workspace = 2 })''))
        (key "SUPER + quotedbl" (act ''hl.dsp.focus({ workspace = 3 })''))
        (key "SUPER + apostrophe" (act ''hl.dsp.focus({ workspace = 4 })''))
        (key "SUPER + parenleft" (act ''hl.dsp.focus({ workspace = 5 })''))
        (key "SUPER + SHIFT + ampersand" (act ''hl.dsp.window.move({ workspace = 1 })''))
        (key "SUPER + SHIFT + eacute" (act ''hl.dsp.window.move({ workspace = 2 })''))
        (key "SUPER + SHIFT + quotedbl" (act ''hl.dsp.window.move({ workspace = 3 })''))
        (key "SUPER + SHIFT + apostrophe" (act ''hl.dsp.window.move({ workspace = 4 })''))
        (key "SUPER + SHIFT + parenleft" (act ''hl.dsp.window.move({ workspace = 5 })''))
        (key "Print" (cmd ''grim -g "$(slurp)" - | wl-copy''))
        { _args = [ "XF86AudioRaiseVolume" (cmd "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+") { locked = true; repeating = true; } ]; }
        { _args = [ "XF86AudioLowerVolume" (cmd "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-") { locked = true; repeating = true; } ]; }
        { _args = [ "XF86AudioMute" (cmd "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle") { locked = true; } ]; }
        { _args = [ "XF86MonBrightnessUp" (cmd "brightnessctl set 5%+") { locked = true; repeating = true; } ]; }
        { _args = [ "XF86MonBrightnessDown" (cmd "brightnessctl set 5%-") { locked = true; repeating = true; } ]; }
      ];
    };
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      general.hide_cursor = true;
      background = [ { path = "screenshot"; blur_passes = 2; blur_size = 6; } ];
      input-field = [{
        size = "280, 52";
        position = "0, -90";
        monitor = "";
        dots_center = true;
        outer_color = "rgb(7aa2f7)";
        inner_color = "rgb(111827)";
        font_color = "rgb(e5e7eb)";
      }];
      label = [{
        text = "$TIME";
        color = "rgb(e5e7eb)";
        font_size = 64;
        position = "0, 80";
        halign = "center";
        valign = "center";
      }];
    };
  };
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };
      listener = [
        { timeout = 300; on-timeout = "loginctl lock-session"; }
        { timeout = 600; on-timeout = "hyprctl dispatch dpms off"; on-resume = "hyprctl dispatch dpms on"; }
      ];
    };
  };
}
