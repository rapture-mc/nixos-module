_: {
  programs.nixvim = {
    keymaps = [
      {
        action = "<cmd>CHADopen<CR>";
        key = "<C-n>";
        mode = "n";
      }
      {
        action = "<cmd>UndotreeToggle<CR>";
        key = "<C-u>";
        mode = "n";
      }
      {
        action = "<cmd>Telescope<CR>";
        key = "<leader>t";
        mode = "n";
      }
      {
        action = "<cmd>LazyGit<CR>";
        key = "<leader>g";
        mode = "n";
      }
      {
        action = "<cmd>BufferPrevious<CR>";
        key = "<A-,>";
        mode = "n";
      }
      {
        action = "<cmd>BufferNext<CR>";
        key = "<A-.>";
        mode = "n";
      }
      {
        action = "<cmd>BufferClose<CR>";
        key = "<A-c>";
        mode = "n";
      }
      {
        action = "<cmd>BufferRestore<CR>";
        key = "<A-s-c>";
        mode = "n";
      }
    ];
  };
}
