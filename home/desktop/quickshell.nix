{ ... }:
{
  programs.quickshell = {
    enable = true;
    configs.ade = ./quickshell;
    activeConfig = "ade";
  };
}
