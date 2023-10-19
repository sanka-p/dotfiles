local opts = { noremap = true, silent = true }

-- shorten function name
local keymap = vim.api.nvim_set_keymap

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c"

keymap("i", "jk", "<Esc>:w<CR>", opts)
keymap("v", "jk", "<Esc>:w<CR>", opts)
keymap("n", "<leader>q", ":wqa<CR>", opts)

-- nvim-tree binds
keymap("n", "<leader>fe", ":NvimTreeToggle<CR>", opts)
keymap("n", "<leader>nr", ":NvimTreeRefresh<CR>", opts)
keymap("n", "<leader>nf", ":NvimTreeFindFile<CR>", opts)
