 _: {
  imports = [fastfetch/default.nix];

  programs = {
    nushell = {
      enable = true;
      loginFile.text = ''
        $env.config.buffer_editor = "nvim"
        $env.config.show_banner = false
        fastfetch
      '';

      shellAliases = {
        v = "vi";
        ra = "ranger";
      };
    };

    oh-my-posh = {
      enable = true;
      enableNushellIntegration = true;
      useTheme = "atomicBit";
    };

    zoxide = {
      enable = true;
      enableNushellIntegration = true;
    };
  };
}
