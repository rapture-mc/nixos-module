{
  lib,
  config,
  ...
}: let
  cfg = config.megacorp.config.nixvim;

  inherit
    (lib)
    mkIf
    mkEnableOption
    ;
in {
  imports = [
    ./plugins.nix
    ./keymaps.nix
  ];

  options.megacorp.config.nixvim = {
    enable = mkEnableOption "Whether to enable Nixvim";
  };

  config = mkIf cfg.enable {
    programs.nixvim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      colorschemes.catppuccin.enable = true;
      globals.mapleader = " ";
      opts = {
        number = true;
        relativenumber = true;
        cursorline = true;
        shiftwidth = 2;
        termguicolors = true;
        undofile = true;
        tabstop = 4;
        expandtab = true;
      };
    };
  };
}
