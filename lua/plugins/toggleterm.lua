return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup {
      direction = "float"
    }
  end,
  keys = {
    {
      "<leader>gg",
      function()
        local Terminal = require("toggleterm.terminal").Terminal
        local lazygit = Terminal:new({
          cmd = "lazygit",
          hidden = true,
          direction = "float",
        })
        lazygit:toggle()
      end,
      desc = "Toggle Lazygit",
    },
    {
      "<leader>tt",
      function()
        local Terminal = require("toggleterm.terminal").Terminal
        local float_term = Terminal:new({
          cmd = "fish",
          hidden = true,
          direction = "float",
        })
        float_term:toggle()
      end,
      desc = "Toggle Terminal",
    }
  },
}
