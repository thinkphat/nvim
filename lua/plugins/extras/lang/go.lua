local utils = require("utils")

vim.keymap.set("n", "<leader>rr", function()
  vim.cmd("w")
  vim.cmd("split | term go run " .. vim.fn.expand("%"))
end, { desc = "Run Go file" })

vim.keymap.set("n", "<leader>rb", function()
  vim.cmd("w")
  vim.cmd("split | term go build .")
end, { desc = "Build Go project" })

vim.keymap.set("n", "<leader>rt", function()
  vim.cmd("w")
  vim.cmd("split | term go test ./...")
end, { desc = "Run Go tests" })

return {
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = utils.merge_with_unique_lists({
      ensure_installed = {
        "gopls",
        "goimports",
        "gofumpt",
        "delve",
      },
    }),
  },

  {
    "ray-x/go.nvim",
    dependencies = { "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter", },
    config = function()
      require("go").setup({
        lsp_cfg = true,
        lsp_keymaps = true,
        lsp_codelens = true,
        lsp_inlay_hints = {
          enable = true,
        },
        dap_debug = true,
      })
    end,
    event = { "CmdlineEnter" },
    ft = { "go", "gomod" },
    build = ':lua require("go.install").update_all_sync()',
  },

  {
    "stevearc/conform.nvim",
    opts = utils.merge_with_unique_lists({
      formatters_by_ft = {
        go = { "goimports", "gofumpt" },
      },
    }),
  },

  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "leoluz/nvim-dap-go",
    },
    config = function()
      require("dap-go").setup()
    end,
  },
}
