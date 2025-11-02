---@type LazyPluginSpec
return {
  "nvim-telescope/telescope.nvim",
  event = "VimEnter",
  branch = "0.1.x",
  keys = {
    {
      "<leader>sh",
      "<cmd>lua require('telescope.builtin').help_tags()<CR>",
      desc = "Telescope: Show Help Tags",
    },
    {
      "<leader>sk",
      "<cmd>lua require('telescope.builtin').keymaps()<CR>",
      desc = "Telescope: List Keymaps",
    },
    {
      "<leader>sf",
      "<cmd>lua require('telescope.builtin').find_files()<CR>",
      desc = "Telescope: Find Files",
    },
    {
      "<leader>ss",
      "<cmd>lua require('telescope.builtin').builtin()<CR>",
      desc = "Telescope: List Pickers",
    },
    {
      "<leader>sw",
      "<cmd>lua require('telescope.builtin').grep_string()<CR>",
      desc = "Telescope: Grep Current Word",
    },
    {
      "<leader>sg",
      "<cmd>lua require('telescope.builtin').live_grep()<CR>",
      desc = "Telescope: Live Grep Search",
    },
    {
      "<leader>sd",
      "<cmd>lua require('telescope.builtin').diagnostics()<CR>",
      desc = "Telescope: Show Diagnostics",
    },
    {
      "<leader>sr",
      "<cmd>lua require('telescope.builtin').resume()<CR>",
      desc = "Telescope: Resume Last Picker",
    },
    {
      "<leader>s.",
      "<cmd>lua require('telescope.builtin').oldfiles()<CR>",
      desc = "Telescope: Recent Files",
    },
    {
      "<leader><leader>",
      function()
        require("telescope.builtin").buffers({
          sort_lastused = true,
          ignore_current_buffer = true,
          attach_mappings = function(prompt_bufnr, map)
            local actions = require("telescope.actions")
            map("i", "<c-d>", function()
              actions.delete_buffer(prompt_bufnr)
            end)
            map("n", "<c-d>", function()
              actions.delete_buffer(prompt_bufnr)
            end)
            return true
          end,
        })
      end,
      desc = "Telescope: Open Buffers (with delete)",
    },
    {
      "<leader>sn",
      "<cmd>lua require('telescope.builtin').find_files({ cwd = vim.fn.stdpath('config') })<CR>",
      desc = "Telescope: Neovim Config Files",
    },

    {
      "gd",
      "<cmd>lua require('telescope.builtin').lsp_definitions()<CR>",
      desc = "[G]oto [D]efinition",
    },
    {
      "gr",
      "<cmd>lua require('telescope.builtin').lsp_references()<CR>",
      desc = "[G]oto [R]eferences",
    },
    {
      "gI",
      "<cmd>lua require('telescope.builtin').lsp_implementations()<CR>",
      desc = "[G]oto [I]mplementation",
    },
    {
      "<leader>D",
      "<cmd>lua require('telescope.builtin').lsp_type_definitions()<CR>",
      desc = "Type [D]efinition",
    },
    {
      "<leader>ds",
      "<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>",
      desc = "[D]ocument [S]ymbols",
    },
    {
      "<leader>ws",
      "<cmd>lua require('telescope.builtin').lsp_dynamic_workspace_symbols()<CR>",
      desc = "[W]orkspace [S]ymbols",
    },
  },
  dependencies = {
    "nvim-lua/plenary.nvim",
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },
    { "nvim-telescope/telescope-ui-select.nvim" },
  },
  config = function()
    local actions = require("telescope.actions")

    require("telescope").setup({
      pickers = {
        buffers = {
          sort_lastused = true,
          initial_mode = "normal",
          mappings = {
            i = { ["<c-d>"] = actions.delete_buffer },
            n = { ["<c-d>"] = actions.delete_buffer },
          },
        },
      },
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown(),
        },
      },
    })

    pcall(require("telescope").load_extension, "fzf")
    pcall(require("telescope").load_extension, "ui-select")
  end,
}
