{pkgs, ...}: {
  programs.nixvim = {
    plugins = {
      cmp = {
        enable = true;
        settings = {
          sources = [
            {name = "nvim_lsp";}
            {name = "buffer";}
            {name = "path";}
          ];
          mapping = {
            "<C-j>" = "cmp.mapping.select_next_item()";
            "<C-k>" = "cmp.mapping.select_prev_item()";
            "<C-S-j>" = "cmp.mapping.scroll_docs(4)";
            "<C-S-k>" = "cmp.mapping.scroll_docs(-4)";
            "<C-Space>" = "cmp.mapping.complete()";
          };
        };
      };
      cmp-nvim-lsp.enable = true;
      lsp-lines.enable = true;
      alpha = {
        enable = true;
        theme = "startify";
      };
      lualine.enable = true;
      chadtree.enable = true;
      telescope.enable = true;
      treesitter.enable = true;
      barbar.enable = true;
      gitgutter.enable = true;
      comment.enable = true;
      autoclose.enable = true;
      lsp = {
        enable = true;
        servers = {
          nixd = {
            enable = true;
            settings = {
              nixpkgs.expr = "import <nixpkgs> { }";
              options.nixos.expr = "(builtins.getFlake \"git+https://github.com/rapture-mc/mgc-machines\").nixosConfigurations.MGC-HVS-01.options";
            };
          };
          gopls.enable = true;
          terraformls.enable = true;
        };
      };
    };
    extraPlugins = with pkgs.vimPlugins; [
      lazygit-nvim
      vim-ledger
      vim-table-mode
    ];
  };
}
