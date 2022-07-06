require("nvim-treesitter.configs").setup {
    ensure_installed = { "c", "lua", "python", "bash", "latex" },
    ignore_install = { "javascript" },
    highlight = {
            enable = true,
    },
    indent = {
            enable = true,
    },
}
