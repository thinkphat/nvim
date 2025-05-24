return {
  {
    "stevearc/oil.nvim",
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      skip_confirm_for_simple_edits = true,
      view_options = {
        show_hidden = true,
      },
    },
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    keys = {
      {
        "-",
        "<cmd>Oil<CR>",
        desc = "Oil: Open File Explorer",
        mode = { "n", "x" },
      },
    },
    lazy = false,
  },
}
