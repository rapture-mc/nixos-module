 _: {
  programs = {
    nushell = {
      enable = true;
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
