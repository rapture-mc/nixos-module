 _: {
  programs = {
    nushell = {
      enable = true;
      shellAliases = {
        v = "vi";
        ra = "ranger";
      };
    };

    zoxide = {
      enable = true;
      enableNushellIntegration = true;
    };
  };
}
