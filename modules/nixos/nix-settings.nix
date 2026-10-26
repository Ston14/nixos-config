{ ... }:

{
  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      sandbox = true;
      require-sigs = true;

      trusted-users = [
        "root"
      ];
    };
  };
}
