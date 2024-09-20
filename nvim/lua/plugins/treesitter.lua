return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function () 
            local configs = require("nvim-treesitter.configs")

            configs.setup({
                ensure_installed = { 
			"bash",
			"c",
			"cpp",
			"css",
			"csv",
			"dockerfile",
			"git_config",
			"git_rebase",
			"html",
			"java",
			"javascript", 
			"json",
			"latex",
			"lua", 
			"nginx",
			"python",
			"sql",
			"tmux",
			"typescript",
			"verilog",
			"vim",
		},
                sync_install = false,
		auto_install = true,
                highlight = { enable = true },
                indent = { enable = true },  
                })
        end
    }
}
