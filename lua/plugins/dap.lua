return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
    "nvim-neotest/nvim-nio",
    "williamboman/mason.nvim",
    "jay-babu/mason-nvim-dap.nvim",
  },

  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    -- Mason ensure delve installed
    require("mason-nvim-dap").setup({
      ensure_installed = { "delve" },
      automatic_installation = true,
    })

    ----------------------------------------------------------------------
    -- Go DAP Adapter (host debugging)
    ----------------------------------------------------------------------

    dap.adapters.go = {
      type = "server",
      port = "${port}",
      executable = {
        command = "dlv",
        args = { "dap", "-l", "127.0.0.1:${port}" },
      },
    }

    dap.configurations.go = {
      {
        type = "go",
        name = "Debug Gin (Host)",
        request = "launch",
        program = "${workspaceFolder}/cmd/server",
      },
    } ----------------------------------------------------------------------
    -- UI + Bindings
    ----------------------------------------------------------------------
    require("nvim-dap-virtual-text").setup()
    dapui.setup()

    vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Start/Continue" })
    vim.keymap.set("n", "<F1>", dap.step_into, { desc = "Debug: Step Into" })
    vim.keymap.set("n", "<F2>", dap.step_over, { desc = "Debug: Step Over" })
    vim.keymap.set("n", "<F3>", dap.step_out, { desc = "Debug: Step Out" })
    vim.keymap.set("n", "<F4>", dap.run_last, { desc = "Debug: Step Out" })
    vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
    vim.keymap.set("n", "<F7>", dapui.toggle, { desc = "DAP UI Toggle" })

    dap.listeners.after.event_initialized["dapui"] = dapui.open
    dap.listeners.before.event_terminated["dapui"] = dapui.close
    dap.listeners.before.event_exited["dapui"] = dapui.close
    vim.fn.sign_define("DapBreakpoint", {
      text = "●",
      texthl = "DapBreakpoint",
      linehl = "",
      numhl = "",
    })

    vim.fn.sign_define("DapBreakpointRejected", {
      text = "●",
      texthl = "DapBreakpointRejected",
      linehl = "",
      numhl = "",
    })

    vim.fn.sign_define("DapStopped", {
      text = "➤",
      texthl = "DapStopped",
      linehl = "DapStoppedLine",
      numhl = "",
    })

    vim.cmd([[
      highlight DapBreakpoint guifg=#FF4B4B
      highlight DapBreakpointRejected guifg=#FF0000
      highlight DapStopped guifg=#00FF00
      highlight DapStoppedLine guibg=#333333
    ]])
  end,
}
