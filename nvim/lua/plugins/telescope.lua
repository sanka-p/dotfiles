return {
    {
        'nvim-telescope/telescope.nvim', 
        tag = '0.1.8',
        dependencies = { 'nvim-lua/plenary.nvim' },
        opts = {
            defaults = {
               file_ignore_patterns = { ".git" },
            },
        },
        keys = {
            {'<leader>sh', '<cmd>Telescope help_tags<cr>', desc = '[S]earch [H]elp'},
            {'<leader>sk', '<cmd>Telescope keymaps<cr>', desc = '[S]earch [K]eymaps'},
            {'<leader>sf', '<cmd>Telescope find_files<cr>', desc = '[S]earch [F]iles'},
            {'<leader>ss', '<cmd>Telescope builtin<cr>', desc = '[S]earch [S]elect Telescope'},
            {'<leader>sw', '<cmd>Telescope grep_string<cr>', desc = '[S]earch current [W]ord'},
            {'<leader>sg', '<cmd>Telescope live_grep<cr>', desc = '[S]earch by [G]rep'},
            {'<leader>sd', '<cmd>Telescope diagnostics<cr>', desc = '[S]earch [D]iagnostics'},
            {'<leader>sr', '<cmd>Telescope resume<cr>', desc = '[S]earch [R]esume'},
            {'<leader>s.', '<cmd>Telescope oldfiles<cr>', desc = '[S]earch Recent Files ("." for repeat)'},
            {'<leader><leader>', '<cmd>Telescope buffers<cr>', desc = '[ ] Find existing buffers'},
            {'<leader>sb', "<cmd>Telescope buffers<cr>", desc = "[S]earch [B]uffers"},
  
        },
    },
}     
