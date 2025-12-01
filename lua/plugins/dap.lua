return {
  {
    "mfussenegger/nvim-dap",
    enabled = false,
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio", -- REQUIRED for dap-ui
    },

    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      --------------------------------------------------------------------
      -- DAP Adapter (Delve via Docker Remote)
      --------------------------------------------------------------------

      dap.adapters.go = function(callback, config)
        -- Evaluate port if it's a function
        local port = config.port
        if type(port) == "function" then
          port = port()
        end

        callback({
          type = "server",
          host = config.host or "127.0.0.1",
          port = port,
        })
      end
      local project_root = vim.fn.getcwd()
      dap.configurations.go = {
        {
          type = "go",
          name = "Attach to Docker (Custom Port)",
          request = "attach",
          mode = "remote",

          host = "127.0.0.1",
          port = function()
            local p = vim.fn.input("Enter debug port (default 2345): ")
            if p == "" then
              return 2345
            end
            return tonumber(p)
          end,

          substitutePath = {
            -- Ánh xạ từ đường dẫn container (/app) sang thư mục gốc của host
            { from = "/app",     to = project_root },

            -- (Tùy chọn) Thử ánh xạ cho binary nếu cần
            { from = "/app/bin", to = project_root .. "/bin" },
          },
        },
      }

      --------------------------------------------------------------------
      -- DAP UI + Virtual Text
      --------------------------------------------------------------------
      require("nvim-dap-virtual-text").setup()
      dapui.setup()

      --------------------------------------------------------------------
      -- Keymaps
      --------------------------------------------------------------------
      local map = vim.keymap.set
      map("n", "<F5>", dap.continue, { desc = "Debug: Start/Continue" })
      map("n", "<F1>", dap.step_into, { desc = "Debug: Step Into" })
      map("n", "<F2>", dap.step_over, { desc = "Debug: Step Over" })
      map("n", "<F3>", dap.step_out, { desc = "Debug: Step Out" })
      map("n", "<F4>", dap.run_last, { desc = "Debug: Run Last" })
      map("n", "<leader>b", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
      map("n", "<leader>B", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, { desc = "Conditional Breakpoint" })
      map("n", "<F7>", dapui.toggle, { desc = "Toggle Debug UI" })

      --------------------------------------------------------------------
      -- Auto open/close UI
      --------------------------------------------------------------------
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
      --------------------------------------------------------------------
      -- Custom Breakpoint Icons (Red Dot)
      --------------------------------------------------------------------
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
  },
}
