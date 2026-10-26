{ ... }:

{
  programs.tmux = {
    enable = true;

    mouse = true;
    keyMode = "vi";
    historyLimit = 50000;

    clock24 = true;
  };
}
