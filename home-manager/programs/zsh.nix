_: {
  imports = [fastfetch/default.nix];

  programs = {
    zsh = {
      enable = true;
      loginExtra = "fastfetch";
      autosuggestion.enable = true;
      sessionVariables = {
        TERM = "xterm-256color";
        EDITOR = "vim";
        LS_COLORS = "$LS_COLORS:'di=0;32:'";
      };

      shellAliases = {
        v = "vi";
        ra = "ranger";
        nix-list-generations = "nix profile history --profile /nix/var/nix/profiles/system";
      };

      oh-my-zsh = {
        enable = true;
        theme = "fino-time";
        plugins = ["tmux"];
      };
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    lsd = {
      enable = true;
      enableAliases = true;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
