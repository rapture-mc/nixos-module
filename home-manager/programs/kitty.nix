{
  osConfig,
  lib,
  ...
}: {
  programs = lib.mkIf osConfig.megacorp.config.desktop.enable {
    kitty = {
      enable = true;
      shellIntegration.enableZshIntegration = true;
      theme = "Argonaut";
      extraConfig = ''
        background_opacity 0.8
      '';
      font = {
        size = 13.0;
        name = "Terminus";
      };
    };
  };
}
