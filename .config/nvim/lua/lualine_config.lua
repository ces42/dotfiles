local custom_theme = require'lualine.themes.powerline_dark'
custom_theme.normal.c.fg = '#50EF70'
custom_theme.command.c.fg = '#50EF70'

custom_theme.normal.a.bg = '#EFF810'

custom_theme.inactive.a.fg = '#A0A0A0'
custom_theme.inactive.b.fg = '#A0A0A0'
custom_theme.inactive.c.fg = '#A0A0A0'

-- local function modified()
--   if vim.bo.modified then
--     return '+'
--   elseif vim.bo.modifiable == false or vim.bo.readonly == true then
--     return '-'
--   end
--   return ''
-- end

-- https://github.com/nvim-lualine/lualine.nvim/issues/335#issuecomment-916759033 {{{
local custom_fname = require('lualine.components.filename'):extend()
local highlight = require'lualine.highlight'
local default_status_colors = {
    --saved = '#228B22',
    modified = '#c00060'
}

function custom_fname:init(options)
    custom_fname.super.init(self, options)
    self.status_colors = {
        saved = highlight.create_component_highlight_group(
            {bg = default_status_colors.saved}, 'filename_status_saved', self.options),
        modified = highlight.create_component_highlight_group(
            {bg = default_status_colors.modified, fg='#eff810'}, 'filename_status_modified', self.options),
    }
    if self.options.color == nil then self.options.color = '' end
end

function custom_fname:update_status()
    local data = custom_fname.super.update_status(self)
    data = highlight.component_format_highlight(vim.bo.modified
        and self.status_colors.modified
        or self.status_colors.saved) .. data
    return data
end
--}}}

function dbg(a)
    vim.fn.system("echo '" .. vim.inspect(a):gsub('\n', ' '):gsub('\t', ' ') .. "' > /tmp/fifo2")
end

-- https://github.com/nvim-lualine/lualine.nvim/issues/186#issuecomment-968392445 {{{

Search_width = 0
local function search_cnt()
    local res = vim.fn.searchcount({recompute = 1, maxcount = 0, timeout = 50})
    -- dbg('search_cnt')
    -- dbg(vim.fn.Searchcount())
    -- dbg(res)
    if res.total > 0 then
        local s = vim.fn.getreg("/")
        local disp = ''
        if string.len(s) <= 12 then
            disp = s
        else
            disp = string.sub(s, 1, 11) .. '…'
        end
        ret = string.gsub(string.format("/%s %s/%s",
            disp,
            res.current < 100 and res.current or '>99',
            res.total < 100 and res.total or '>99'
        ),
            '%%', '%%%%'
        )
        Search_width = #ret
        return ret
    else
        Search_width = 0
        return ""
    end
end

-- local function search_cnt()
--     local s = vim.fn.Searchcount()
--     Search_width = #s
--     return s
-- end

-- }}}


local function format_mode(data)
    local available_width = (vim.fn.winwidth(0)
    - #vim.fn.bufname()
    -- - math.min(#vim.fn.getreg("/"), 12)
    - Search_width
    - 26 -- parts x y z
    - 4 -- padding
)
    if vim.bo.modified then
        available_width = available_width -  5
    end
    if available_width < #data then
        return data:sub(1,1)
    end
    return data
end


require'lualine'.setup {
    options = {
        icons_enabled = true,
        theme = custom_theme,
        component_separators = { left = '', right = ''},
        section_separators = { left = '', right = ''},
        disabled_filetypes = {},
        always_divide_middle = true,
    },
    sections = {
        lualine_a = {{
            'mode',
            fmt = format_mode,
        }},
        lualine_b = {'branch', 'diff', 'diagnostics'},
        lualine_c = {
            { custom_fname, file_status = true, path = 1 },
            --{modified, color = {bg = '#FF4C51', fg='#FFFFFFF', gui = 'bold'}}
        },
        lualine_x = {
            'encoding',
            -- {'fileformat', symbols = {unix = '', dos = '', mac = ''}},
            {'fileformat', symbols = {unix = '', dos = '', mac = ''}},
            'filetype'
        },
        lualine_y = {'progress', search_cnt},
        --lualine_y = {'progress'}
        lualine_z = {'location'}
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {{ 'filename', file_status = true, path = 1}},
        lualine_x = {'location'},
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    extensions = {'fzf', 'fugitive'}
}
