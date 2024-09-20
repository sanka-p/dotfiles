return {
    {
        "neovim/nvim-lspconfig",
    },
    {
        "williamboman/mason.nvim",
        opts = {},
    },
    {
        "williamboman/mason-lspconfig.nvim",
        opts = {
            ensure_installed = {
               "html",
               "jdtls",
               "eslint", -- javascript, typescript
               "cssls",
               "tailwindcss",
            },
         },
    },
    {
        "hrsh7th/nvim-cmp",
    },
    {
        "hrsh7th/cmp-nvim-lsp",
    },
    {
        "hrsh7th/cmp-buffer",
    },
    {
        "hrsh7th/cmp-path",
    },
}
