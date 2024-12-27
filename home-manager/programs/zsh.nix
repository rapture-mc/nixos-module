_: {
  imports = [fastfetch/default.nix];

  programs = {
    zsh = {
      enable = true;
      loginExtra = "fastfetch";
      autosuggestion.enable = true;
      sessionVariables = {
        TERM = "xterm-256color";
        EDITOR = "vi";
      };
      shellAliases = {
        v = "vi";
        ".." = "cd ..";
        "..2" = "cd ../..";
        "..3" = "cd ../../..";
        "..4" = "cd ../../../..";
        nix-list-generations = "nix profile history --profile /nix/var/nix/profiles/system";
      };
      oh-my-zsh = {
        enable = true;
        theme = "fino-time";
        plugins = ["tmux" "terraform" "kubectl"];
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
