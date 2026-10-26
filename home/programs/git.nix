
{ ... }:

{
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "Ston14";
        email = "alexis.debrito@pm.me";
      };

      init.defaultBranch = "main";

      pull.rebase = true;
      rebase.autoStash = false;

      core.editor = "nvim";

      fetch.prune = true;

      diff.colorMoved = "default";

      alias = {
        st = "status -sb";
        lg = "log --oneline --graph --decorate -15";
        last = "log -1 --stat";
      };
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;

    options = {
      navigate = true;
      side-by-side = false;
      line-numbers = true;
      syntax-theme = "none";
    };
  };
}

