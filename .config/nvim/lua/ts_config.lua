require'nvim-treesitter.configs'.setup {
  parser_install_dir = '/home/ca/.local/share/nvim/lazy/nvim-treesitter/',
  -- ensure_installed = {'python', 'latex', 'lua', 'c', 'bash', 'javascript', 'yaml', 'vim', 'help'},
  -- ignore_install = { "javascript" },
  highlight = {
      enable = true,
  },
  indent = {
      enable = true,
  },
  context_commentstring = { enable = true, enable_autocmd = false },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<C-space>",
      node_incremental = "<C-space>",
      scope_incremental = "<S-S-space>",
      node_decremental = "<C-bs>",
    },
  },
  textobjects = {
    select = {
      enable = true,

      -- Automatically jump  -- linewiseforward to textobj, similar to targets.vim
      --lookahead = true,

      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@call.outer",
        ["if"] = "@call.inner",
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
        ["ab"] = "@block.outer",
        ["ib"] = "@block.inner",
        ["al"] = "@loop.outer",
        ["il"] = "@loop.inner",
        ["ad"] = "@function.outer",
        ["id"] = "@function.inner",

        --["ac"] = "@class.outer",
        --["ic"] = "@class.inner"
        -- You can optionally set descriptions to the mappings (used in the desc parameter of
        -- nvim_buf_set_keymap) which plugins like which-key display
        --["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
      },
      -- You can choose the select mode (default is charwise 'v')
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * method: eg 'v' or 'o'
      -- and should return the mode ('v', 'V', or '<c-v>') or a table
      -- mapping query_strings to modes.
      selection_modes = {
        ['@parameter.outer'] = 'v',
        ['@call.outer'] = 'v',
        ['@function.outer'] = 'V',
        ['@loop.outer'] = 'V',
        --['@class.outer'] = '<c-v>', -- blockwise
      },
      -- If you set this to `true` (default is `false`) then any textobject is
      -- extended to include preceding or succeeding whitespace. Succeeding
      -- whitespace has priority in order to act similarly to eg the built-in
      -- `ap`.
      --
      -- Can also be a function which gets passed a table with the keys
      -- * query_string: eg '@function.inner'
      -- * selection_mode: eg 'v'
      -- and should return true of false
      include_surrounding_whitespace = false,
    },
  },
  ignore_install = {"tex", "latex"},
  highlight = {
    enable = true,
    disable = {"latex", "tex"},
  },
}

require('Comment').setup{ignore='^$'}

---Textobject for adjacent commented lines https://github.com/numToStr/Comment.nvim/issues/22#issuecomment-1272569139
local function commented_lines_textobject()
	local U = require("Comment.utils")
	local cl = vim.api.nvim_win_get_cursor(0)[1] -- current line
	local range = { srow = cl, scol = 0, erow = cl, ecol = 0 }
	local ctx = {
		ctype = U.ctype.linewise,
		range = range,
	}
	local cstr = require("Comment.ft").calculate(ctx) or vim.bo.commentstring
	local ll, rr = U.unwrap_cstr(cstr)
	local padding = true
	local is_commented = U.is_commented(ll, rr, padding)

	local line = vim.api.nvim_buf_get_lines(0, cl - 1, cl, false)
	if next(line) == nil or not is_commented(line[1]) then
		return
	end

	local rs, re = cl, cl -- range start and end
	repeat
		rs = rs - 1
		line = vim.api.nvim_buf_get_lines(0, rs - 1, rs, false)
	until next(line) == nil or not is_commented(line[1])
	rs = rs + 1
	repeat
		re = re + 1
		line = vim.api.nvim_buf_get_lines(0, re - 1, re, false)
	until next(line) == nil or not is_commented(line[1])
	re = re - 1

	vim.fn.execute("normal! " .. rs .. "GV" .. re .. "G")
end

vim.keymap.set("o", "gc", commented_lines_textobject,
	{ silent = true, desc = "Textobject for adjacent commented lines" })
vim.keymap.set("o", "u", commented_lines_textobject,
	{ silent = true, desc = "Textobject for adjacent commented lines" })
