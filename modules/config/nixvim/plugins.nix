{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.megacorp.config.nixvim;

  inherit
    (lib)
    mkIf
    ;
in {
  config = mkIf cfg.enable {
    programs.nixvim = {
      plugins = {
        cmp = {
          enable = true;
          autoEnableSources = true;
          settings = {
            sources = [
              {name = "nvim_lsp";}
              {name = "buffer";}
              {name = "path";}
              {name = "cmdline";}
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
        web-devicons.enable = true;
        lualine.enable = true;
        noice.enable = true;
        # notify.enable = true;
        # nui.enable = true;
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
              settings = let
                flake = ''(builtins.getFlake "github:rapture-mc/mgc-machines)""'';

              in {
                nixpkgs.expr = "import ${flake}.inputs.nixpkgs { }";
                options.nixos.expr = ''${flake}.nixosConfigurations.MGC-LT01.options'';
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
  };
}
