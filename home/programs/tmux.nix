{ ... }:

{
  programs.tmux = {
    enable = true;

    prefix = "C-Space";
    terminal = "tmux-256color";

    mouse = true;
    historyLimit = 50000;
    baseIndex = 1;
    keyMode = "vi";
    escapeTime = 0;
    focusEvents = true;
    clock24 = true;

    extraConfig = ''
      # Terminal
      set -as terminal-overrides ",xterm-256color:RGB"
      set -g xterm-keys on

      # Windows
      set -g renumber-windows on

      # Splits dans le repertoire courant
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      unbind '"'
      unbind %
      bind c new-window -c "#{pane_current_path}"

      # Navigation : Alt + fleches
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D

      # Redimensionnement : Prefix + HJKL
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      # Copy mode Vim
      bind -T copy-mode-vi v send -X begin-selection
      bind -T copy-mode-vi Escape send -X cancel

      # Recharger la configuration generee par Home Manager
      bind r source-file ~/.config/tmux/tmux.conf \; display-message "Config reloaded!"

      # Tokyo Night
      source-file ${../dotfiles/tmux/tokyo-night.conf}
    '';
  };
}
