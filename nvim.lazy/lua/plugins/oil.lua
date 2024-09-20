return {
  -- disable default explorer
  { "nvim-neo-tree/neo-tree.nvim", enabled = true },
  {
    "stevearc/oil.nvim",
    enabled = false,
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    -- Optional dependencies
    dependencies = { { "echasnovski/mini.icons", opts = {} } },
    keys = {
      {
        "<leader>ff",
        function()
          require("oil").open()
        end,
        desc = "[F]ormat buffer",
      },
    },
  },
}
