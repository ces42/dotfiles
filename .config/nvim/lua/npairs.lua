local Rule = require('nvim-autopairs.rule')
local npairs = require('nvim-autopairs')
local cond = require('nvim-autopairs.conds')
local basic = require('nvim-autopairs.rules.basic')
local utils = require('nvim-autopairs.utils')

local opt = {
    map_bs = vim.g.vimtex == nil,
    map_c_w = false,
    map_cr = true,
    disable_filetype = { 'TelescopePrompt', 'spectre_panel' },
    disable_in_macro = false,
    disable_in_visualblock = false,
    ignored_next_char = string.gsub([[ [%w%%%'%[%"%.] ]], '%s+', ''),
    check_ts = false, -- settings this to true made pressing `(` at (text|) only insert a single quote
    enable_moveright = true,
    enable_afterquote = true,
    enable_check_bracket_line = true,
    ts_config = {
        lua = { 'string', 'source' },
        javascript = { 'string', 'template_string' },
    },
}


npairs.setup(opt)

-- re-do setup because the standard rules aren't optimal for latex

-- from nvim-autopairs/rules/basic.lua {{{1
local basic = function(...)
    local move_func = opt.enable_moveright and cond.move_right or cond.none
    local rule = Rule(...)
        :with_move(move_func())
        :with_pair(cond.not_add_quote_inside_quote())

    if #opt.ignored_next_char > 1 then
        rule:with_pair(cond.not_after_regex(opt.ignored_next_char))
    end
    rule:use_undo(true)
    return rule
end

local bracket = function(...)
    if opt.enable_check_bracket_line == true then
        return basic(...)
            :with_pair(cond.is_bracket_line())
    end
    return basic(...)
end

local tex_bracket = function(...)
    local move_func = opt.enable_moveright and cond.move_right or cond.none
    local rule = Rule(...)
        :with_move(move_func())

    -- it's okay to add a closing bracket if before the following characters: }=&
    --local checker = cond.not_after_regex('[%W}=&]')
    rule:with_pair(
        function(opts)
            str = utils.text_sub_char(opts.line, opts.col, 2)
            if (str ~= '') and not str:match('^[%s{})%]=+;,.^_&$"\']') and not str:match('\\}') then
                return false
            end
        end
    )
    --rule:with_pair(cond.not_after_regex('[%W}=&]'))
    rule:use_undo(true)
    rule:with_pair(cond.is_bracket_line())
    return rule
end

local function is_brackets_balanced_around_position(line, open_char, close_char, col)
    local balance = 0
    for i = 1, #line, 1 do
        local c = line:sub(i, i)
        if c == open_char then
            balance = balance + 1
        elseif balance > 0 and c == close_char then
            balance = balance - 1
            if col <= i and balance == 0 then
                break
            end
        end
    end
    return balance == 0
end

-- }}}1


-- So apparently the way condition functions in this plugin are supposed to work is:
--   * returning false means no pair is added **and all subsequent conditions are not checked anymore**
--   * returning true means a pair is added **and all subsequent conditions are not checked anymore**
--   * returning nil means check the next condition - the default at the end is to add a pair

npairs.remove_rule('(')
npairs.remove_rule('[')
npairs.remove_rule('{')
npairs.remove_rule("'")

npairs.add_rules({
    bracket("(", ")", "-tex"),
    bracket("(", ")", "tex")
        :with_move(cond.move_right)
        :with_pair(cond.not_before_text('lr'))
        :with_pair(cond.not_before_text('^')),
    bracket("[", "]", "-tex"),
    tex_bracket("[", "]", "tex")
        --:with_move(cond.move_right)
        :with_pair(cond.not_before_text('lr')),
    bracket("{", "}", "-tex"),
    tex_bracket("{", "}", "tex")
        --:with_move(cond.move_right)
        :with_pair(cond.not_before_text('lr'))
        :with_pair(cond.not_before_text('\\min'))
        :with_pair(cond.not_before_text('\\max'))
        :with_pair(cond.not_before_text('\\')),
    basic("'", "'", {'-tex', '-rust'})
        :with_pair(cond.not_before_regex("%w")),
    --basic("'", "'", "tex")
        --:with_pair(function(opts) if vim.call('vimtex#syntax#in_mathzone') ~= 1 then return false end end)
        --:with_pair(cond.not_before_regex("%w")),
  }
)

npairs.add_rules({
    Rule("$", "$", {"tex", "latex"})
        -- don't add a pair if inside a comment
        :with_pair(function(opts)
            if vim.call('vimtex#syntax#in_comment') == 1 or
                vim.fn['vimtex#syntax#in_mathzone'](vim.fn.line('.'), vim.fn.col('$')-1) == 1
            then
                return false
            end
        end)
        -- not directly after a word character
        :with_pair(cond.not_before_regex('%w'))
        :with_pair(cond.not_before_text('$'))
        -- move right when repeat character
        :with_move(function(opts) return opts.char == '$' end)
        -- disable adding a newline when you press <cr>
        :with_cr(cond.none()),
    Rule("\\{", "\\}", {"tex", "latex"})
        -- only in mathmode
        :with_pair(function(opts) if vim.call('vimtex#syntax#in_mathzone') ~= 1 then return false end end)
        :with_move(function(opts) return opts.char == '}' end),
    Rule('', '\\right]', {"tex", "latex"})
        :with_pair(cond.none())
        :with_move(function(opts) return opts.char == ']' end)
        :with_cr(cond.none())
        :with_del(cond.none())
        :use_key(']'),
    Rule('', '\\right\\}', {"tex", "latex"})
        :with_pair(cond.none())
        :with_move(function(opts) return opts.char == '}' end)
        :with_cr(cond.none())
        :with_del(cond.none())
        :use_key('}'),
    Rule('', '\\right)', {"tex", "latex"})
        :with_pair(cond.none())
        :with_move(function(opts) return opts.char == ')' end)
        :with_cr(cond.none())
        :with_del(cond.none())
        :use_key(')'),
    Rule('', ' \\right]', {"tex", "latex"})
        :with_pair(cond.none())
        :with_move(function(opts) return opts.char == ']' end)
        :with_cr(cond.none())
        :with_del(cond.none())
        :use_key(']'),
    Rule('', ' \\right\\}', {"tex", "latex"})
        :with_pair(cond.none())
        :with_move(function(opts) return opts.char == '}' end)
        :with_cr(cond.none())
:with_del(cond.none())
        :use_key('}'),
    Rule('', ' \\right)', {"tex", "latex"})
        :with_pair(cond.none())
        :with_move(function(opts) if opts.char ~= ')' then return false end end)
        :with_move(function(opts) return is_brackets_balanced_around_position(opts.line, '(', ')', opts.col) end )
:with_cr(cond.none())
        :with_del(cond.none())
        :use_key(')'),
}
)

-- "(|)" -> "( | )" by inserting a space 
-- https://github.com/windwp/nvim-autopairs/wiki/Custom-rules
npairs.add_rules {
    Rule(' ', ' ')
        :with_pair(function(opts)
            local pair = opts.line:sub(opts.col -1, opts.col)
            return vim.tbl_contains({ '()', '{}', '[]' }, pair)
        end)
        :with_move(cond.none())
        :with_cr(cond.none())
        :with_del(function(opts)
            local col = vim.api.nvim_win_get_cursor(0)[2]
            local context = opts.line:sub(col - 1, col + 2)
            return vim.tbl_contains({ '(  )', '{  }', '[  ]' }, context)
        end),
    Rule('', ' )')
        :with_pair(cond.none())
        :with_move(function(opts) return opts.char == ')' end)
        :with_cr(cond.none())
        :with_del(cond.none())
        :use_key(')'),
    Rule('', ' }')
        :with_pair(cond.none())
        :with_move(function(opts) return opts.char == '}' end)
        :with_cr(cond.none())
        :with_del(cond.none())
        :use_key('}'),
    Rule('', ' ]')
        :with_pair(cond.none())
        :with_move(function(opts) return opts.char == ']' end)
        :with_cr(cond.none())
        :with_del(cond.none())
        :use_key(']'),
}
