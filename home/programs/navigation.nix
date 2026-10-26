{ ... }:

{
  programs.fzf = {
    enable = true;
    enableFishIntegration = true;

    defaultOptions = [
      "--height=40%"
      "--layout=reverse"
      "--border"
    ];
  };

  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };
}
