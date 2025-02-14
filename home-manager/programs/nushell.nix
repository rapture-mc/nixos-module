 _: {
  imports = [fastfetch/default.nix];

  programs = {
    nushell = {
      enable = true;
      extraLogin = "fastfetch";
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
