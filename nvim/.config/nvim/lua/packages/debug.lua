return {
    "mfussenegger/nvim-dap",
    event = "VeryLazy",
    dependencies = {
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio",
        "jay-babu/mason-nvim-dap.nvim",
        "theHamsta/nvim-dap-virtual-text",
		"jay-babu/mason-nvim-dap.nvim",
    },
	config = function()
		require("dap").adapters["pwa-node"] = {
		  type = "server",
		  host = "localhost",
		  port = "8123",
		  executable = {
			command = "/home/kayon/.local/share/nvim/mason/bin/js-debug-adapter",
		  }
		}

		require("dap").configurations.javascript = {
		  {
			type = "pwa-node",
			request = "launch",
			name = "Launch file",
			program = "${file}",
			cwd = "${workspaceFolder}",
		  },
		}

		local dap, dapui = require("dap"), require("dapui")
		dapui.setup()
		dap.listeners.before.attach.dapui_config = function()
		  dapui.open()
		end
		dap.listeners.before.launch.dapui_config = function()
		  dapui.open()
		end
		dap.listeners.before.event_terminated.dapui_config = function()
		  dapui.close()
		end
		dap.listeners.before.event_exited.dapui_config = function()
		  dapui.close()
		end
			end,
}
