
{ lib, ... }:

{
  programs.fish.interactiveShellInit = lib.mkAfter ''
    # Tide — Lean, two-line prompt
    # Use global variables, not persistent universal variables.

    set -g tide_left_prompt_items pwd git newline character

    set -g tide_right_prompt_items \
      status cmd_duration context jobs \
      direnv python rustc go nix_shell

    # Lean: no colored backgrounds or frames
    set -g tide_left_prompt_frame_enabled false
    set -g tide_right_prompt_frame_enabled false
    set -g tide_prompt_pad_items false

    # Spacing and prompt behavior
    set -g tide_prompt_add_newline_before true
    set -g tide_prompt_transient_enabled false

    # Git display
    set -g tide_git_truncation_length 24

    # Show duration for commands > 3 seconds
    set -g tide_cmd_duration_threshold 3000

    # Path display
    set -g tide_pwd_truncate_margin 10
  '';
}

