_: {
  imports = [
    ./plugins.nix
    ./keymaps.nix
  ];

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
}
