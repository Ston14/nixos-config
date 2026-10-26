{ ... }:

{
  programs.eza = {
    enable = true;
    enableFishIntegration = false;

    git = true;
    icons = "never";
    colors = "auto";

    extraOptions = [
      "--group-directories-first"
    ];
  };

  programs.fish.shellAbbrs = {
    ll = "eza -lah";
    la = "eza -a";
    lt = "eza --tree --level=2";
  };
}
